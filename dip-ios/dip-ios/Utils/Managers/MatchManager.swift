//
//  MatchManager.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation
import SwiftEntryKit

class MatchManager: ObservableObject {
    static let shared = MatchManager()
    
    @Published var matches: GetUserDashboard?
    
    func fetchMatches(callback: @escaping () -> Void) {
        WebService.getUserDashboard { [weak self] matches, response in
            DispatchQueue.main.async {
                if response.isSuccess, let matches = matches {
                    self?.matches = matches
                } else {
                    SwiftEntryKit.showErrorMessage(message: response.error?.localizedDescription ?? "Matchs indisponnibles")
                }
                callback()
            }
        }
    }
    
    func createMatch(createMatchDto: CreateMatchDto, callback: @escaping(Bool) -> Void) {
        print(createMatchDto)
        WebService.postCreateMatch(createMatchDto: createMatchDto) { response in
            switch response {
            case .success(_):
                SwiftEntryKit.showSuccessMessage(message: "Invitation envoyée avec succès")
                callback(true)
            case .failure(_):
                SwiftEntryKit.showErrorMessage(message: "Vous avez déjà joué avec ce joueur")
            }
        }
    }
}
