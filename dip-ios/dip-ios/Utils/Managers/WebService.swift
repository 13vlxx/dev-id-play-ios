//
//  WebService.swift
//  dip-ios
//
//  Created by Alex ツ on 05/08/2024.
//

import Foundation

class WebService {
    struct Consts {
        static let baseUrl = "https://337c-168-220-131-251.ngrok-free.app"
        
        static func UrlGames() -> URL {
            return URL(string: "\(baseUrl)/games")!
        }
        
        static func UrlUsers() -> URL {
            return URL(string: "\(baseUrl)/users")!
        }
    }
    
    static func getGames(completion: @escaping(_: [Game]?, WebServiceResponse) -> Void) {
        getDataTask(Consts.UrlGames(), completion: completion)
    }

    static func getCurrentUser(completion: @escaping(_: User?, WebServiceResponse) -> Void) {
        getDataTask(Consts.UrlUsers().appendingPathComponent("/me"), completion: completion)
    }
    
    private static func getDataTask<T: Decodable>(_ URL: URL, completion: @escaping (T?, WebServiceResponse) -> Void) {
        dataTask(URL, body: nil, httpMethod: .get, completion: completion)
    }
    
    private static func postDataTask<T: Decodable>(_ URL: URL, body: Data?, completion: @escaping (T?, WebServiceResponse) -> Void) {
        dataTask(URL, body: body, httpMethod: .post, completion: completion)
    }
    
    private static func putDataTask<T: Decodable>(_ URL: URL, body: Data?, completion: @escaping (T?, WebServiceResponse) -> Void) {
        dataTask(URL, body: body, httpMethod: .put, completion: completion)
    }
    
    private static func patchDataTask<T: Decodable>(_ URL: URL, body: Data?, completion: @escaping (T?, WebServiceResponse) -> Void) {
        dataTask(URL, body: body, httpMethod: .patch, completion: completion)
    }
    
    private static func deleteDataTask<T: Decodable>(_ URL: URL, body: Data?, completion: @escaping (T?, WebServiceResponse) -> Void) {
        dataTask(URL, body: body, httpMethod: .delete, completion: completion)
    }
    
    private static func dataTask<T: Decodable>(
        _ URL: URL,
        body: Data?,
        httpMethod: HttpMethod,
        completion: @escaping (T?, WebServiceResponse) -> Void
    ) {
        var urlRequest = URLRequest(url: URL)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        if let token = CurrentUserService.shared.getToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        process(urlRequest: urlRequest, canRetryOnUnauthorized: true, completion: completion)
    }
    
    private static func process<T: Decodable>(
        urlRequest: URLRequest,
        canRetryOnUnauthorized: Bool,
        completion: @escaping (T?, WebServiceResponse) -> Void
    ) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            let webServiceResponse = WebServiceResponse(rawData: data, response: response, error: error)
            if error == nil && webServiceResponse.isSuccess, let data = data, webServiceResponse.statusCode != 204 {
                do {
                    let typedData = try JSONDecoder().decode(T.self, from: data)
                    completion(typedData, webServiceResponse)
                    return
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
            else if webServiceResponse.statusCode == 401 && canRetryOnUnauthorized {
                // Token has expired, refreshing
                return
            }
            completion(nil, webServiceResponse)
        }
        task.resume()
    }
}

class WebServiceResponse {
    let rawData: Data?
    let response: URLResponse?
    let error: Error?
    let statusCode: Int?
    
    var isSuccess: Bool {
        if let statusCode = statusCode, case 200...299 = statusCode {
            return true
        }
        return false
    }
    
    init(rawData: Data?, response: URLResponse?, error: Error?) {
        self.rawData = rawData
        self.response = response
        self.error = error
        statusCode = (response as? HTTPURLResponse)?.statusCode
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
