//
//  Notification.swift
//  dip-ios
//
//  Created by Alex ツ on 08/08/2024.
//

import Foundation

enum NotificationType: String, Decodable {
    case newMatch = "NEW_MATCH"
    case win = "WIN"
    case lose = "LOSE"
    
    func getTitle() -> String {
        switch self {
        case .newMatch:
            return "Nouveau match !"
        case .win:
            return "Victoire !"
        case .lose:
            return "Défaite !"
        }
    }
    
    func getContent() -> String {
        switch self {
        case .win:
            return "Vous avez gagné"
        case .lose:
            return "vous avez perdu"
        @unknown default:
            return ""
        }
    }
}

enum NotificationStatusEnum: String, Decodable {
    case waitingForConfirmation = "WAITING_FOR_CONFIRMATION"
    case accepted = "ACCEPTED"
    case refused = "REFUSED"
}


struct Notification: Hashable, Identifiable, Decodable {
    var id: String
    var notificationType: NotificationType
    var user: String
    var match: Match?
    var status: NotificationStatusEnum?
    var createdBy: User
}
