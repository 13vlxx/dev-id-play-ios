//
//  GameVIewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 25/07/2024.
//

import Foundation

class GameViewModel: BaseViewModel {
    @Published var selectedCity: City {
        didSet {
            selectedGame = nil
        }
    }
    @Published var numberOfPlayers = 2
    @Published var date = Date.now
    @Published var selectedGame: Game?
    @Published var playersId: [String] = []
    
    override init() {
        self.selectedCity = cities[0]
    }

    var cities: [City] = [
        City(id: "1", name: "Marseille"),
        City(id: "2", name: "Toulouse"),
    ]
    
    
    var games: [Game] = [
        Game(id: "1", name: "Uno", imageUrl: .unoGame, gameTime: 15, pointsPerWin: 10, minPlayers: 2, maxPlayers: 8, availableOn: City(id: "1", name: "Marseille")),
        Game(id: "3", name: "Billard", imageUrl: .billardGame, gameTime: 30, pointsPerWin: 20, minPlayers: 2, maxPlayers: 4, availableOn: City(id: "1", name: "Marseille")),
        Game(id: "2", name: "Dos", imageUrl: .unoGame, gameTime: 15, pointsPerWin: 10, minPlayers: 2, maxPlayers: 8, availableOn: City(id: "2", name: "Toulouse"))
    ]
    
    var filteredGames: [Game] {
        games.filter { $0.availableOn.id == selectedCity.id }
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
        return (self.numberOfPlayers - self.playersId.count) - 1
    }
    
    func areAllPlayersSelected() -> Bool {
        return self.getNumberOfPlayersRemainingToSelect() == 0 ? true : false
    }
}
