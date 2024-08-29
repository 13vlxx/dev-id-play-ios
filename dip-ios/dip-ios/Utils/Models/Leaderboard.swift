//
//  Leaderboard.swift
//  dip-ios
//
//  Created by Alex ツ on 27/08/2024.
//

import Foundation

struct LeaderboardPlayer: Decodable, Hashable {
    var player: User
    var score: Int
}
