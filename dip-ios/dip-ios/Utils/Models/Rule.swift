//
//  RUle.swift
//  dip-ios
//
//  Created by Alex ツ on 16/07/2024.
//

import Foundation

struct Rule: Hashable, Codable, Identifiable {
    var id: Int
    var points: Int? = nil
    let description: String
}
