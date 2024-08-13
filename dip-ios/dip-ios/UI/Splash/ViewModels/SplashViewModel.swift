//
//  SplashVIewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 06/08/2024.
//

import Foundation
import SwiftUI

class SplashViewModel: BaseViewModel {
    @Published var isDataLoaded = false
    
    func fetchSplashData() {
        let group = DispatchGroup()
        
        group.enter()
        CurrentUserService.shared.fetchCurrentUser { isSuccess in
            group.leave()
            if !isSuccess {
                CurrentUserService.shared.logout()
                withAnimation {
                    self.isDataLoaded = true
                }
                return
            }
        }
        group.enter()
        GameManager.shared.fetchGames {
            group.leave()
        }
        group.enter()
        MatchManager.shared.fetchMatches {
            group.leave()
        }
        group.enter()
        NotificationManager.shared.fetchNotifications {
            group.leave()
        }
        
        group.notify(queue: .main) {
            withAnimation {
                self.isDataLoaded = true
            }
        }
    }
}
