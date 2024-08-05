//
//  ApiService.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import Foundation
import Combine

class ApiService {
    static let shared = ApiService()
    
    private let baseURL = "http://localhost:3000/api"
    private var cancellables = Set<AnyCancellable>()
    
//    private func request<T: Decodable>(_ endpoint: String, method: String = "GET", body: [String: Any]? = nil) -> AnyPublisher<T, Error> {
//        guard let url = URL(string: baseURL + endpoint) else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        
//        if let body = body {
//            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        }
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: T.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
    // LOGIN WITH GOOGLE
    
//    func loginWithGoogle(_ token: String) -> AnyPublisher<User, Error> {
//        return
//    }
    
    func getAllGames() {}
}
