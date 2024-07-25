//
//  GameView.swift
//  dip-ios
//
//  Created by Alex ツ on 24/07/2024.
//

import SwiftUI

struct GameView: View {
    let game: Game
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(game.name)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(width: 70, alignment: .leading)
                .fontWeight(.medium)
                .padding(.leading, 20)
            
            Spacer()
            
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: "clock.fill")
                    Text("\(game.gameTime)")
                        .fontWeight(.medium)
                    Text("minutes")
                        .font(.system(size: 10, weight: .light))
                }
                
                Divider()
                    .frame(width: 1, height: 24)
                    .background(.neutral)
                
                VStack {
                    Image(systemName: "person.fill")
                    Text("\(game.minPlayers)-\(game.maxPlayers)")
                        .fontWeight(.medium)
                    Text("joueurs")
                        .font(.system(size: 10, weight: .light))
                }
                
                Image(game.imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.trailing, 5)
            }
            .foregroundStyle(.lightNeutral)
        }
        .frame(height: 70)
        .background(RoundedRectangle(cornerRadius: 13).fill(.neutral))
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .stroke(isSelected ? .accent : .clear, lineWidth: 1)
        }
    }
}
