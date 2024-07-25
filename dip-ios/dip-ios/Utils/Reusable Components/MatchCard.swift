//
//  MatchCard.swift
//  dip-ios
//
//  Created by Alex ツ on 19/07/2024.
//

import SwiftUI

enum MatchCardStatus {
    case win
    case loose
    case normal
}

struct MatchCard: View {
    var type: MatchCardStatus
    var gameName: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                Image("UnoGame")
                    .resizable()
                    .frame(height: 166)
                
                if type != MatchCardStatus.normal {
                    HStack {
                        Text(type == MatchCardStatus.win ? "Gagné" : "Perdu")
                            .foregroundStyle(.white)
                            .opacity(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 166 / 2)
                    .background((type == MatchCardStatus.win ? Color(.green) : Color(.red)).opacity(0.4))
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
                Text(gameName)
                
                Spacer()
                
                Text("12 avr. 2023")
                    .font(.system(size: 12))
                    .padding(8)
                    .background(.lightNeutral)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            
            HStack {
                HStack(spacing: -15) {
                    ForEach(0..<3) {_ in
                        Image(systemName: "circle.fill")
                            .overlay {
                                Circle().stroke(.red, lineWidth: 1)
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

#Preview {
    MatchCard(type: MatchCardStatus.normal, gameName: "Uno")
}
