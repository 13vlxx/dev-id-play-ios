//
//  GameVIewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 25/07/2024.
//

import Foundation
import SwiftEntryKit

class GameViewModel: BaseViewModel {
    @Published var selectedCity: City {
        didSet {
            selectedGame = nil
        }
    }
    @Published var numberOfPlayers = 2
    @Published var date = Date.now
    @Published var selectedGame: Game?
    @Published var playersId: [String] = [CurrentUserService.shared.currentUser!.id]
    @Published var players: [User] = []
    @Published var errorMessage: String?
    @Published var games = GameManager.shared.games
    @Published var search = ""
    
    override init() {
        self.selectedCity = cities[0]
        super.init()
    }
    
    func fetchPlayers() {
        WebService.getAllUsers { [weak self] users, response in
            DispatchQueue.main.async {
                if response.isSuccess, let users = users {
                    self?.players = users.filter { $0.id != CurrentUserService.shared.currentUser?.id }
                    print(users)
                } else {
                    SwiftEntryKit.showErrorMessage(message: "No players")
                }
            }
        }
    }
    
    func refresh() {
        GameManager.shared.fetchGames {
            self.games = GameManager.shared.games
        }
    }

    var cities: [City] = [
        City(id: "1", name: "Marseille"),
        City(id: "2", name: "Toulouse"),
    ]
    
    var filteredGames: [Game] {
        return games.filter { game in
            game.availableOn.contains { city in
                city.name == selectedCity.name
            }
        }
    }
    
    func selectGame(game: Game) {
        if numberOfPlayers > game.maxPlayers {
            self.numberOfPlayers = game.maxPlayers
        }
        selectedGame = game
    }
    
    func incrementNumberOfPlayers() {
        if numberOfPlayers < selectedGame!.maxPlayers {
            self.numberOfPlayers += 1
        }
    }
    
    func decrementNumberOfPlayers() {
        if numberOfPlayers > selectedGame?.minPlayers ?? 0 {
            self.numberOfPlayers -= 1
        }
    }
    
    func addPlayer(playerId: String) {
        if !areAllPlayersSelected() {
            self.playersId.append(playerId)
        }
    }
    
    func removePlayer(index: Int) {
        self.playersId.remove(at: index)
    }
    
    func getNumberOfPlayersRemainingToSelect() -> Int {
        return (self.numberOfPlayers - self.playersId.count)
    }
    
    func areAllPlayersSelected() -> Bool {
        return self.getNumberOfPlayersRemainingToSelect() == 0 ? true : false
    }
    
    func createMatch() {
        
    }
}
