//
//  LoginViewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import Foundation

class LoginViewModel: BaseViewModel {
    func login(_ token: String) {
        CurrentUserService.shared.setToken(token)
    }
}
