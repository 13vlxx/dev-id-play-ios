//
//  MatchCard.swift
//  dip-ios
//
//  Created by Alex ツ on 19/07/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct MatchCard: View {
    var match: Match
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                WebImage(url: URL(string: match.game.imageUrl))
                    .resizable()
                    .frame(height: 166)
                
                if let currentUserId = CurrentUserService.shared.currentUser?.id {
                    if match.status == .finished {
                        HStack {
                            Text(match.winners.contains(where: { $0.id == currentUserId }) ? "Gagné" : "Perdu")
                                .foregroundStyle(.white)
                                .opacity(1)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 166 / 2)
                        .background((match.winners.contains(where: { $0.id == currentUserId }) ? Color(.green) : Color(.red)).opacity(0.4))
                    }
                }
            }
            makeMatchInfos()
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension MatchCard {
    func makeMatchInfos() -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(match.game.name)
                
                Spacer()
                
                Text(formatDateString(match.date))
                    .font(.system(size: 12))
                    .padding(8)
                    .background(.lightNeutral)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            HStack {
                HStack(spacing: -15) {
                    ForEach(match.players.filter {$0.id != CurrentUserService.shared.currentUser?.id}) { u in
                        WebImage(url: URL(string: u.logoUrl))
                            .resizable()
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 1)
                            }
                            .frame(width: 25, height: 25)
                    }
                }
                
                Spacer()
                
                Text("15:30")
                    .font(.system(size: 12))
                    .padding(8)
                    .background(.lightNeutral)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(.neutral)
    }
}
