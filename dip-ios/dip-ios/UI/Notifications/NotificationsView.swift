//
//  NotificationsView.swift
//  dip-ios
//
//  Created by Alex ツ on 17/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import EventKit

struct NotificationsView: View {
    @StateObject private var notificationsVM = NotificationsViewModel()
    
    var body: some View {
        VStack {
            makeHeader()
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(NotificationManager.shared.notifications.reversed()) { n in
                        switch n.notificationType {
                        case .newMatch:
                            NewMatchNotification(notification: n)
                        case .win, .lose:
                            WinLoseNotification(notification: n)
                        }
                    }
                    .padding(.horizontal, 8)
                    .onAppear {
                        notificationsVM.refreshNotifications()
                    }
                }
                Spacer().frame(height: 20)
            }
            .offset(y: -40)
        }
        .ignoresSafeArea()
    }
}

extension NotificationsView {
    func makeHeader() -> some View {
        ZStack {
            Image("RulePicture")
                .resizable()
                .scaledToFit()
            
            Text("Notifications")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding(.horizontal)
                .offset(y: -20)
            
        }
    }
    
    func NewMatchNotification(notification: Notification) -> some View {
        HStack {
            ZStack {
                WebImage(url: URL(string: notification.createdBy.logoUrl ?? ""))
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
            }
            .frame(width: 95)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(notification.notificationType.getTitle()).font(.system(size: 15, weight: .bold))
                    Spacer()
                    Text("il y'a 6min")
                        .font(.system(size: 13))
                        .foregroundStyle(.lightNeutral)
                }
                Text("\(notification.createdBy.firstname) vous défie au \(notification.match?.game.name ?? "")")
                    .font(.system(size: 13))
                
                Text("15:30")
                    .font(.system(size: 12))
                    .padding(4)
                    .background(.lightNeutral)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                HStack(spacing: 20) {
                    if notification.status == .waitingForConfirmation {
                        Button {
                            notificationsVM.updateNotificationStatus(notificationId: notification.id, status: .accepted)
                        } label: {
                            Text("Accepter")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.black)
                        
                        Button("Refuser") {
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                    } else {
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .frame(width: 35, height: 35)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.black)
                        }
                        
                        Button("Ajouter au calendrier") {
                            addEventToCalendar()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                        .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
        }
        .padding(15)
        .background(.neutral)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    func WinLoseNotification(notification: Notification) -> some View {
        HStack {
            ZStack {
                WebImage(url: URL(string: notification.match?.game.imageUrl ?? ""))
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
            }
            .frame(width: 95)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(notification.notificationType.getTitle()).font(.system(size: 15, weight: .bold))
                    Spacer()
                    Text("il y'a 6min")
                        .font(.system(size: 13))
                        .foregroundStyle(.lightNeutral)
                }
                Text("\(notification.notificationType.getContent()) \(notification.match?.game.name ?? "")")
                    .font(.system(size: 13))
            }
        }
        .padding(15)
        .background(.neutral)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private func addEventToCalendar() {
    let eventStore = EKEventStore()
    let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    
    switch authorizationStatus {
    case .notDetermined:
        // Request access
        eventStore.requestFullAccessToEvents { granted, error in
            if granted {
                saveEvent(eventStore: eventStore)
            } else {
                print("Access to calendar not granted")
            }
        }
    case .authorized:
        saveEvent(eventStore: eventStore)
    case .denied:
        print("Access to calendar was previously denied")
    case .restricted:
        print("Access to calendar is restricted")
    @unknown default:
        print("Unknown authorization status")
    }
}

func saveEvent(eventStore: EKEventStore) {
    let event = EKEvent(eventStore: eventStore)
    event.title = "New Event"
    event.startDate = Date() // Set the start date
    event.endDate = Date().addingTimeInterval(3600) // Set the end date (1 hour later)
    event.calendar = eventStore.defaultCalendarForNewEvents
    
    do {
        try eventStore.save(event, span: .thisEvent)
        print("Event added to calendar")
    } catch let error as NSError {
        print("Failed to save event with error: \(error)")
    }
}

#Preview {
    NotificationsView()
}
