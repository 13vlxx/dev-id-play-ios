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
    
    func getAllGames() {
    }
}
