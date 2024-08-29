//
//  User.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import Foundation

struct User: Identifiable, Decodable, Hashable {
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var logoUrl: String?
    var medals: Medals
    var stats: Stats?
    
    struct Medals: Decodable, Hashable {
        var bronze: Double
        var silver: Double
        var gold: Double
    }
    
    struct Stats: Decodable, Hashable {
        var points: Double
        var rank: Double
        var matchesPlayed: Double
    }
    
    func getFullName() -> String {
        return self.firstname + " " + self.lastname
    }
}
