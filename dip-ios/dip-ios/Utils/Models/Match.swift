//
//  Match.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation

enum MatchStatusEnum: String, Codable {
    case waitingForConfirmation = "WAITING_FOR_CONFIRMATION"
    case upcoming = "UPCOMING"
    case waitingForResult = "WAITING_FOR_RESULT"
    case finished = "FINISHED"
}

struct Match: Hashable, Identifiable, Decodable {
    var id: String
    var game: Game
    var date: String
    var players: [User]
    var status: MatchStatusEnum
    var winners: [User]
}

struct LiteMatch: Hashable, Identifiable, Decodable {
    var id: String
    var game: LiteGame
    var date: String
    var status: String
}

struct GetUserDashboard: Decodable {
    var upcoming: [Match] = []
    var finished: [Match] = []
}

struct CreateMatchDto: Encodable {
    var gameId: String
    var date: String
    var playersId: [String]
}

struct CreateMatchResponseDto: Decodable {
    var game: String
    var date: String
    var players: [String]
    var status: MatchStatusEnum
    var winners: [String]
    var deletedAt: String?
    var id: String
    var createdAt: String
    var updatedAt: String
    var version: Int

    // CodingKeys to map JSON keys to Swift property names
    private enum CodingKeys: String, CodingKey {
        case game
        case date
        case players
        case status
        case winners
        case deletedAt
        case id = "_id"
        case createdAt
        case updatedAt
        case version = "__v"
    }
}

struct UpdateMatchDto: Encodable {
    var status: MatchStatusEnum
    var winners: [String]?
}
