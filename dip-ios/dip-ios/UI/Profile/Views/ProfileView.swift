//
//  ProfileView.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var currentUser = CurrentUserService.shared
    
    var body: some View {
        ScrollView {
            VStack {
                makeHeader()
            }
        }
    }
}

extension ProfileView {
    func makeHeader() -> some View {
        ZStack {
            GeometryReader { g in
                Image(.rulePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(height: g.frame(in: .global).minY > 0 ? 150 + g.frame(in: .global).minY : 150)
                    .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                    .animation(.none, value: UUID())
            }
            .animation(.none, value: UUID())
            .frame(height: 150)
            
            VStack {
                Text("Profile")
                
                if let currentUser = currentUser.currentUser {
                    Text(currentUser.firstname + " " + currentUser.lastname)
                        .font(.system(size: 24, weight: .semibold))
                }
                
                Button ("Logout") {
                    currentUser.logout()
                }
            }
            .font(.system(size: 30))
            .fontWeight(.bold)
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    ProfileView()
}
