//
//  ContentView.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userService = CurrentUserService.shared
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.neutral)
    }
    
    var body: some View {
        VStack {
            if userService.isLoggedIn {
                VStack {
                    TabView {
                        HomeView()
                            .tabItem {
                                Image(systemName: "gamecontroller.fill")
                                Text("Jeux")
                            }
                        
                        LeaderboardView()
                            .tabItem {
                                Image(systemName: "atom")
                                Text("Classement")
                            }
                        
                        RuleView()
                            .tabItem {
                                Image(systemName: "book.fill")
                                Text("Règles")
                            }
                        
                        NotificationsView()
                            .tabItem {
                                Image(systemName: "bell.fill")
                                Text("Notifications")
                            }
                    }
                }
                .transition(.move(edge: .trailing))
                .animation(.easeInOut, value: userService.isLoggedIn)
            } else {
                LoginView()
                .transition(.move(edge: .leading))
                .animation(.easeInOut, value: userService.isLoggedIn)
            }
        }
    }
}

#Preview {
    ContentView()
}
