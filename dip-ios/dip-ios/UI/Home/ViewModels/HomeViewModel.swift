//
//  HomeViewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 06/08/2024.
//

import Foundation

class HomeViewModel: BaseViewModel {
    @Published var logo: String
    
    override init() {
        self.logo = CurrentUserService.shared.currentUser?.logoUrl ?? ""
    }
}
