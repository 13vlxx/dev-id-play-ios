//
//  Match.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation

struct Match: Hashable, Identifiable, Decodable {
    var id: String
    var game: Game
    var date: String
    var players: [User]
    var status: String
    var winners: [User]
}

struct GetUserDashboard: Decodable {
    var upcoming: [Match]
    var finished: [Match]
}
