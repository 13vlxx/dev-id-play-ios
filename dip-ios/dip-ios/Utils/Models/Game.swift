//
//  Game.swift
//  dip-ios
//
//  Created by Alex ツ on 25/07/2024.
//

import Foundation
import SwiftUI

struct Game: Hashable, Identifiable, Decodable {
    var id: String
    var name: String
    var imageUrl: String
    var gameTime: Int
    var pointsPerWin: Int
    var minPlayers: Int
    var maxPlayers: Int
    var availableOn: [City]
}

struct LiteGame: Hashable, Identifiable, Decodable {
    var id: String
    var name: String
    var imageUrl: String
}
