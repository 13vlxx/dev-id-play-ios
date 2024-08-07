//
//  GameManager.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation

class GameManager: ObservableObject {
    static let shared = GameManager()
    
    @Published var games = [Game]()
    
    func fetchGames(callback: @escaping () -> Void) {
        WebService.getGames { [weak self] games, response in
            DispatchQueue.main.async {
                if response.isSuccess, let games = games {
                    self?.games = games
                } else {
//                    TODO: self?.errorMessage = "Une erreur est survenue lors du chargement des jeux."
//                    print("Erreur de chargement : \(self?.errorMessage ?? "")")
                }
                callback()
            }
        }
    }
}
