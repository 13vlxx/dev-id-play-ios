//
//  LeaderboardView.swift
//  dip-ios
//
//  Created by Alex ツ on 17/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct LeaderboardView: View {
    @ObservedObject var currentUser = CurrentUserService.shared
    @StateObject var leaderboardVM = LeaderboardViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                makeHeader()
                
                makeLeaderboard()
            }
        }
        .onAppear {
            leaderboardVM.fetchLeaderboard()
        }
    }
}

extension LeaderboardView {
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
            
            
            VStack(spacing: 20) {
                Text("Classement du mois")
                Text("29j 12h 23min")
                    .font(.system(size: 16))
            }
            .font(.system(size: 30))
            .fontWeight(.bold)
            .padding(.horizontal)
            .frame(height: 120)
            
        }
    }
    
    func makePodium() -> some View {
        VStack {
            
        }
    }
    
    func makePlayer(player: LeaderboardPlayer, position: Int, isHighlight: Bool = false, showProfilePicture: Bool = true) -> some View {
        HStack {
            Text("\(position)")
                .font(.system(size: 28, weight: .black))
            Spacer()
                .frame(width: 24)
            if showProfilePicture == true {
                WebImage(url: URL(string: player.player.logoUrl ?? ""))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(lineWidth: 1)
                    }
            }
            Spacer()
                .frame(width: 14)
            Text(player.player.getFullName())
                .font(.system(size: 15))
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text("\(player.score) pts")
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(player.player.id == currentUser.currentUser?.id && isHighlight == true ? .accent : .neutral)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func makeLeaderboard() -> some View {
        VStack {
            let currentUserIndex = leaderboardVM.leaderbaord.firstIndex { $0.player.id == currentUser.currentUser?.id }

            ForEach(Array(leaderboardVM.leaderbaord.enumerated()), id: \.element) { index, p in
                if let userIndex = currentUserIndex, userIndex > 4, index == 0 {
                    makePlayer(player: leaderboardVM.leaderbaord[userIndex], position: userIndex + 1, isHighlight: true, showProfilePicture: false)
                }
                
                if index <= 4 || p.player.id == currentUser.currentUser?.id {
                    makePlayer(player: p, position: index + 1, isHighlight: (p.player.id == currentUser.currentUser?.id), showProfilePicture: true)
                }
            }
        }
        .padding()
        .background(.neutral)
        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 12, topTrailing: 12)))
    }
}
#Preview {
    LeaderboardView()
}
