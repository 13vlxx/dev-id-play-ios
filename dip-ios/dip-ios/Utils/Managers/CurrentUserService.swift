//
//  CurrentUserService.swift
//  dip-ios
//
//  Created by Alex ツ on 05/08/2024.
//

import Foundation
import SwiftUI

class CurrentUserService: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
        }
    }
    @Published var currentUser: User?
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "authToken"
    private let isLoggedInKey = "isLoggedIn"
    
    static let shared = CurrentUserService()
    
    private init() {
        self.isLoggedIn = userDefaults.bool(forKey: isLoggedInKey)
        checkLoginStatus()
    }
    
    func getToken() -> String? {
        return userDefaults.string(forKey: tokenKey)
    }
    
    func setToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
        DispatchQueue.main.async {
            withAnimation {
                self.isLoggedIn = true
            }
        }
    }
    
    func fetchCurrentUser(callback: @escaping (Bool) -> Void) {
        guard getToken() != nil else {
            print("No token available")
            callback(false)
            return
        }
        
        WebService.getMe { [weak self] (user, response) in
            DispatchQueue.main.async {
                if response.isSuccess, let user = user {
                    self?.currentUser = user
                    print("User fetched successfully: \(user.getFullName())")
                } else {
                    print("Failed to fetch user")
                    self?.logout()
                }
                callback(true)
            }
        }
    }
    
    func logout() {
        userDefaults.removeObject(forKey: tokenKey)
        DispatchQueue.main.async {
            withAnimation {
                self.isLoggedIn = false
            }
        }
        currentUser = nil
    }
    
    private func checkLoginStatus() {
        let token = getToken()
        withAnimation {
            DispatchQueue.main.async {
                self.isLoggedIn = token != nil
            }
        }
    }
}
