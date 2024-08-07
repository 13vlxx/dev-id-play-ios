//
//  MatchManager.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation

class MatchManager: ObservableObject {
    static let shared = MatchManager()
    
    @Published var matches: GetUserDashboard?
    
    func fetchMatches(callback: @escaping () -> Void) {
        WebService.getUserDashboard { [weak self] matches, response in
            DispatchQueue.main.async {
                if response.isSuccess, let matches = matches {
                    self?.matches = matches
                } else {
//                    TODO: self?.errorMessage = "Une erreur est survenue lors du chargement des jeux."
//                    print("Erreur de chargement : \(self?.errorMessage ?? "")")
                }
                callback()
            }
        }
    }

}
