//
//  CreateMatchView.swift
//  dip-ios
//
//  Created by Alex ツ on 24/07/2024.
//

import SwiftUI

struct CreateMatchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var gameVM = GameViewModel()
    @State private var navigateToNextView = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                makeTopContent()
                
                makeAvailableGames()
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color(.dark))
            .navigationTitle("Nouvelle partie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Suivant") {
                        navigateToNextView = true
                    }
                    .disabled(gameVM.selectedGame == nil)
                    .foregroundStyle(gameVM.selectedGame == nil ? .lightNeutral : .accent)
                }
            }
            .navigationDestination(isPresented: $navigateToNextView) {
                SelectPlayersView(gameVM: gameVM)
            }
        }
    }
}

extension CreateMatchView {
    func makeTopContent() -> some View {
        VStack(spacing: 20) {
            Picker("", selection: $gameVM.selectedCity) {
                ForEach(gameVM.cities) { city in
                    Text(city.name)
                        .tag(city)
                }
            }
            .pickerStyle(.segmented)
            
            HStack(spacing: 24) {
                Text("Joueurs")
                    .font(.system(size: 17))
                
                Spacer()
                
                Button {
                    gameVM.decrementNumberOfPlayers()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .disabled(gameVM.numberOfPlayers <= gameVM.selectedGame?.minPlayers ?? 2)
                
                Text(gameVM.numberOfPlayers.description)
                    .font(.system(size: 30, weight: .bold))
                
                Button {
                    gameVM.incrementNumberOfPlayers()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .disabled(gameVM.numberOfPlayers >= gameVM.selectedGame?.maxPlayers ?? 1)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.neutral)
            )
            
            HStack(spacing: 10) {
                Text("Quand ?")
                    .font(.system(size: 17))
                
                Spacer()
                
                DatePicker(selection: $gameVM.date, in: Date.now..., displayedComponents: .date) {}
                    .padding(.trailing, -35)
                
                DatePicker(selection: $gameVM.date, in: Date.now..., displayedComponents: .hourAndMinute) {}
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.neutral)
            )
        }
        .padding(.vertical, 14)
    }
    
    func makeAvailableGames() -> some View {
        VStack(spacing: 10) {
            ForEach(gameVM.filteredGames) { g in
                GameView(game: g, isSelected: gameVM.selectedGame == g)
                    .onTapGesture {
                        gameVM.selectGame(game: g)
                    }
            }
        }
    }
}

#Preview {
    CreateMatchView()
}
