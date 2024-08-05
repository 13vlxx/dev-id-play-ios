import Foundation
import AuthenticationServices
import CommonCrypto
import Combine

class OAuthManager: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = OAuthManager()
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let CLIENT_ID = "264454505993666562@dev-id_play"
    private let REDIRECT_URI = "com.alexmonac13.dip-ios://oauth2redirect"
    private let ISSUER_URI = "https://sso.dev2.dev-id.fr"
    
    private var codeVerifier: String?
    private var authSession: ASWebAuthenticationSession?
    
    var callbackScheme: String {
        return URL(string: REDIRECT_URI)?.scheme ?? ""
    }
      
    private override init() {
        super.init()
    }
    
    func generateCodeVerifier() -> String {
        var bytes = [UInt8](repeating: 0, count: 64)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
    
    func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
    
    func authenticate(callback: @escaping (String?, String?) -> Void) {
        print("authenticate called")
        codeVerifier = generateCodeVerifier()
        let codeChallenge = sha256(codeVerifier ?? "")
        
        var components = URLComponents(string: "\(ISSUER_URI)/oauth/v2/authorize")
        let queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: CLIENT_ID),
            URLQueryItem(name: "redirect_uri", value: REDIRECT_URI),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "scope", value: "openid profile email")
        ]
        components?.queryItems = queryItems
        
        guard let authURL = components?.url else {
            print("Invalid auth URL")
            callback(nil, nil)
            return
        }
        
        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackScheme) { [weak self] callbackURL, error in
            self?.isLoading = true
            if let error = error {
                self?.isLoading = false
                self?.errorMessage = "Authentication error: \(error.localizedDescription)"
                print("Authentication error: \(error.localizedDescription)")
                callback(nil, nil)
                return
            }
            
            guard let url = URLComponents(string: callbackURL?.absoluteString ?? ""),
                  let code = url.queryItems?.first(where: { $0.name == "code" })?.value else {
                self?.isLoading = false
                self?.errorMessage = "Invalid callback URL"
                print("Invalid callback URL")
                callback(nil, nil)
                return
            }
            
            self?.exchangeCodeForToken(code: code) { accessToken, refreshToken in
                self?.isLoading = false
                print("Access Token: \(accessToken ?? "nil")")
                print("Refresh Token: \(refreshToken ?? "nil")")
                callback(accessToken, refreshToken)
            }
        }
        
        authSession?.presentationContextProvider = self
        authSession?.start()
    }
    
    private func exchangeCodeForToken(code: String, callback: @escaping (String?, String?) -> Void) {
        guard let tokenURL = URL(string: "\(ISSUER_URI)/oauth/v2/token") else {
            print("Invalid token URL")
            callback(nil, nil)
            return
        }
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestBody = "client_id=\(CLIENT_ID)&grant_type=authorization_code&code=\(code)&redirect_uri=\(REDIRECT_URI)&code_verifier=\(codeVerifier ?? "")"
        request.httpBody = requestBody.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error in token exchange: \(error?.localizedDescription ?? "Unknown error")")
                callback(nil, nil)
                return
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let accessToken = jsonResponse["access_token"] as? String
                let refreshToken = jsonResponse["refresh_token"] as? String
                callback(accessToken, refreshToken)
            } else {
                print("Failed to parse JSON response")
                callback(nil, nil)
            }
        }
        task.resume()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
