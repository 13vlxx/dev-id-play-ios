//
//  MatchResultsSheet.swift
//  dip-ios
//
//  Created by Alex ツ on 13/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct MatchResultsSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var homeVM: HomeViewModel
    var match: Match
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 14) {
                        Spacer().frame(height: 16)
                        MatchCard(match: match)
                        
                        if match.status == .waitingForResult {
                            HStack {
                                Image(systemName: "trophy.fill")
                                
                                Text("Tu dois sélectionner le/les vainqueurs(s)")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 24)
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .regular))
                        }
                        
                        makePlayersList()
                    }
                }
                
                if match.status == .waitingForResult {
                    Text("N’oublie pas : en cas d’ex-aequo c’est Random.org qui tranche !")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(.lightNeutral)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.horizontal, 20)
            .background(Color(.dark))
            .navigationTitle("Résultats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if match.status == .waitingForResult {
                        Button("Valider") {
                            homeVM.updateWinners { isSuccess in
                                if isSuccess { dismiss() }
                            }
                        }
                        .foregroundStyle(homeVM.winnersId.count == 0 ? .lightNeutral :.accent)
                        .disabled(homeVM.winnersId.count == 0)
                    }
                }
            }

        }
    }
}

extension MatchResultsSheet {
    func makePlayer(player: User, isChecked: Bool) -> some View {
        HStack {
            WebImage(url: URL(string: player.logoUrl ?? ""))
                .resizable()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(lineWidth: 1)
                }
            
            VStack(alignment: .leading){
                Text(player.getFullName())
                Text("100000 pts")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            if isChecked {
                Image(systemName: "checkmark")
                    .foregroundStyle(.accent)
            }
        }
        .padding()
    }
    
    func makePlayersList() -> some View {
        VStack(spacing: 10) {
            ForEach(match.players) { p in
                VStack(spacing:0) {
                    makePlayer(
                        player: p,
                        isChecked: (match.status == .waitingForResult)
                        ? homeVM.winnersId.contains(where: {$0 == p.id})
                        : match.status == .upcoming
                        ? false
                        : match.winners.contains(where: {$0.id == p.id}))
                        .onTapGesture {
                            if match.status == .waitingForResult {
                                if let index = homeVM.winnersId.firstIndex(of: p.id) {
                                    homeVM.removeWinner(index: index)
                                } else {
                                    homeVM.addWinner(playerId: p.id)
                                }
                            }
                        }
                    Divider()

                }           
            }
        }
    }
}

//#Preview {
//    MatchResultsSheet()
//}
