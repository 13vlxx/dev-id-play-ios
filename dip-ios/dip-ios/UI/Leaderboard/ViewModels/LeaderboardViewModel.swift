//
//  LeaderboardViewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 27/08/2024.
//

import Foundation
import SwiftEntryKit

class LeaderboardViewModel: BaseViewModel {
    @Published var leaderbaord = [LeaderboardPlayer]()
    
    func fetchLeaderboard() {
        WebService.getLeaderboard { [weak self] players, response in
            DispatchQueue.main.async {
                if response.isSuccess, let players = players {
                    self?.leaderbaord = players
                    print(players)
                } else {
                    SwiftEntryKit.showErrorMessage(message: "Une erreur est survenue lors de la récupération du classement.")
                }
            }
        }
    }
}
