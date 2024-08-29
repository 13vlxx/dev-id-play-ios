//
//  MatchManager.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation
import SwiftEntryKit
import UserNotifications

class MatchManager: ObservableObject {
    static let shared = MatchManager()
    
    @Published var matches: GetUserDashboard?
    
    func fetchMatches(callback: @escaping () -> Void) {
        WebService.getUserDashboard { [weak self] matches, response in
            DispatchQueue.main.async {
                if response.isSuccess, let matches = matches {
                    self?.matches = matches
                } else {
                    SwiftEntryKit.showErrorMessage(message: response.error?.localizedDescription ?? "Matchs indisponnibles")
                }
                callback()
            }
        }
    }
    
    func createMatch(createMatchDto: CreateMatchDto, callback: @escaping(Bool) -> Void) {
        WebService.postCreateMatch(createMatchDto: createMatchDto) { response in
            switch response {
            case .success(_):
                SwiftEntryKit.showSuccessMessage(message: "Invitation envoyée avec succès")
                self.createNotification()
                callback(true)
            case .failure(_):
                SwiftEntryKit.showErrorMessage(message: "Vous avez déjà joué avec ce joueur")
            }
        }
    }
    
    func createNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
                
                //                let content = UNMutableNotificationContent()
                //                content.title = "Match !"
                //                content.body = "Le match contre"
                //
                //                var dateComponents = DateComponents()
                //                dateComponents.calendar = Calendar.current
                //
                //                dateComponents.weekday = 4
                //                dateComponents.hour = 10
                //                dateComponents.minute = 57
                //
                //                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                //
                //                let uuidString = UUID().uuidString
                //                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                //
                //                let notificationCenter = UNUserNotificationCenter.current()
                //                do {
                //                    try notificationCenter.add(request)
                //                } catch {
                //                    //
                //                }
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
}
