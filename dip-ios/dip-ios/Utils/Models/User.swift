//
//  User.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var logoUrl: String
    var medals: Medals
    
    struct Medals: Decodable {
        var bronze: Double
        var silver: Double
        var gold: Double
    }
}
