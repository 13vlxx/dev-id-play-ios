//
//  ContentView.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userService = CurrentUserService.shared
    @StateObject private var splashVM = SplashViewModel()
    @State private var showSecondarySplash = true
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.neutral)
    }
    
    var body: some View {
        ZStack {
            if splashVM.isDataLoaded == false {
                SplashView(splashVM: splashVM)
            }
            else if userService.isLoggedIn && splashVM.isDataLoaded {
                if showSecondarySplash {
                    SplashView(splashVM: splashVM)
                        .onAppear {
                            DispatchQueue.main.async {
                                withAnimation {
                                    showSecondarySplash = false
                                }
                            }
                        }
                } else {
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
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
