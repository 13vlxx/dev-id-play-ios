//
//  CurrentUserService.swift
//  dip-ios
//
//  Created by Alex ツ on 05/08/2024.
//

import Foundation

class CurrentUserService: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
        }
    }
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
        isLoggedIn = true
    }
    
    func logout() {
        userDefaults.removeObject(forKey: tokenKey)
        isLoggedIn = false
    }
    
    private func checkLoginStatus() {
        let token = getToken()
        isLoggedIn = token != nil
    }
}
