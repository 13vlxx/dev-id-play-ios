//
//  NotificationManager.swift
//  dip-ios
//
//  Created by Alex ツ on 08/08/2024.
//

import Foundation
import SwiftEntryKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications = [Notification]()
    
    func fetchNotifications(callback: @escaping () -> Void) {
        WebService.getUserNotifications { notifications, response in
            DispatchQueue.main.async {
                if response.isSuccess, let notifications = notifications {
                    self.notifications = notifications
                } else {
                    SwiftEntryKit.showErrorMessage(message: response.error?.localizedDescription ?? "Notifications indisponnibles")
                }
                callback()
            }
        }
    }
}
