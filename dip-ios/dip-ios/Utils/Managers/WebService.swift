//
//  WebService.swift
//  dip-ios
//
//  Created by Alex ツ on 05/08/2024.
//

import Foundation
import SwiftEntryKit
import Alamofire

class WebService {
    struct Consts {
        static let baseUrl = "https://6caa-5-104-196-125.ngrok-free.app/api"
        
        static func UrlGames() -> URL {
            return URL(string: "\(baseUrl)/games")!
        }
        
        static func UrlUsers() -> URL {
            return URL(string: "\(baseUrl)/users")!
        }
        
        static func UrlMatches() -> URL {
            return URL(string: "\(baseUrl)/matches")!
        }
        
        static func UrlNotifications() -> URL {
            return URL(string: "\(baseUrl)/notifications")!
        }
    }
    
    // USERS
    
    static func getAllUsers(completion: @escaping(_: [User]?, WebServiceResponse) -> Void) {
        getDataTask(Consts.UrlUsers(), completion: completion)
    }

    static func getMe(completion: @escaping(_: User?, WebServiceResponse) -> Void) {
        getDataTask(Consts.UrlUsers().appendingPathComponent("/me"), completion: completion)
    }
    
    // GAMES
    
    static func getGames(completion: @escaping(_: [Game]?, WebServiceResponse) -> Void) {
        getDataTask(Consts.UrlGames(), completion: completion)
    }
    
    // MATCHES
    
    static func getUserDashboard(completion: @escaping(_: GetUserDashboard?, WebServiceResponse) -> Void) {
        getDataTask(Consts.UrlMatches().appendingPathComponent("/home"), completion: completion)
    }
    
    static func postCreateMatch(createMatchDto: CreateMatchDto, completion: @escaping (Result<CreateMatchResponseDto, Error>) -> Void) {
        let url = Consts.UrlMatches()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CurrentUserService.shared.getToken()!)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: createMatchDto, encoder: JSONParameterEncoder.default, headers: headers)
            .response { response in
                if let data = response.data {
                    print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                }
                print("Response status code: \(response.response?.statusCode ?? 0)")
            }
            .responseDecodable(of: CreateMatchResponseDto.self) { response in
                switch response.result {
                case .success(let createMatchResponse):
                    completion(.success(createMatchResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func putUpdateMatch(matchId: String, updateMatchDto: UpdateMatchDto, completion: @escaping (Bool) -> Void) {
        let url = Consts.UrlMatches().appendingPathComponent("/\(matchId)")
        
        var parameters: [String: Any] = [
            "status": updateMatchDto.status.rawValue
        ]
        
        if let winners = updateMatchDto.winners {
            parameters["winners"] = winners
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CurrentUserService.shared.getToken()!)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                if let error = response.error {
                    completion(false)
                    SwiftEntryKit.showErrorMessage(message: "Error: \(error)")
                } else if let httpResponse = response.response, httpResponse.statusCode == 204 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
    
    // NOTIFICATIONS
    
    static func getUserNotifications(completion: @escaping(_: [Notification]?, WebServiceResponse) -> Void){
        getDataTask(Consts.UrlNotifications(), completion: completion)
    }
    
    static func putUpdateNotificationStatus(notificationId: String, status: NotificationStatusEnum, callback: @escaping (Bool) -> Void) {
        let url = Consts.UrlNotifications().appendingPathComponent("/\(notificationId)")
        
        // Combine parameters and body into a single dictionary
        let parameters: [String: Any] = [
            "status": status.rawValue
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CurrentUserService.shared.getToken()!)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                if let error = response.error {
                    SwiftEntryKit.showErrorMessage(message: "Error: \(error)")
                    callback(false)
                } else if let httpResponse = response.response, httpResponse.statusCode == 204 {
                    callback(true)
                } else {
                    SwiftEntryKit.showErrorMessage(message: "Unexpected response: \(response)")
                }
            }
    }
    
    
    // CONFIG
    
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
                print("___________________________________________________ -> RESPONSE")
                print(data)
                do {
                    let typedData = try JSONDecoder().decode(T.self, from: data)
                    print("___________________________________________________ -> TYPED RESPONSE JSON")
                    print(typedData)
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
