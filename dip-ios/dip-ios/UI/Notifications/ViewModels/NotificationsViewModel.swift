//
//  NotificationsViewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 12/08/2024.
//

import Foundation

class NotificationsViewModel: BaseViewModel {
    @Published var notifications = NotificationManager.shared.notifications
    
    func refreshNotifications() {
        NotificationManager.shared.fetchNotifications {
            self.notifications = NotificationManager.shared.notifications
        }
    }
    
    func updateNotificationStatus(notificationId: String, status: NotificationStatusEnum) {
        WebService.putUpdateNotificationStatus(notificationId: notificationId, status: status) { isSuccess in
            self.refreshNotifications()
        }
    }
}
