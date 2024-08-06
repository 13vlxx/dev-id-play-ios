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
    @Published var games: [Game] = []
    @Published var errorMessage: String?
    
    override init() {
        self.selectedCity = cities[0]
        super.init()
        loadGames()
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
    
    func loadGames() {
        isLoading = true
        errorMessage = nil
        
        WebService.getGames { [weak self] games, response in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if response.isSuccess, let games = games {
                    self?.games = games
                } else {
                    self?.errorMessage = "Une erreur est survenue lors du chargement des jeux."
                    print("Erreur de chargement : \(self?.errorMessage ?? "")")
                }
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
        return (self.numberOfPlayers - self.playersId.count) - 1
    }
    
    func areAllPlayersSelected() -> Bool {
        return self.getNumberOfPlayersRemainingToSelect() == 0 ? true : false
    }
}
