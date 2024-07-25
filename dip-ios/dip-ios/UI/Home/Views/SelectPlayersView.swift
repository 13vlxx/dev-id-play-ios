//
//  SelectPlayersView.swift
//  dip-ios
//
//  Created by Alex ツ on 24/07/2024.
//

import SwiftUI

struct SelectPlayersView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gameVM: GameViewModel
    @State private var search: String = ""
    @State private var selectedPlayers: [String] = []
    private var players = ["Alexandru Rusescu", "Alexis Serbelloni"]
    
    init(gameVM: GameViewModel) {
        self.gameVM = gameVM
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    makeTopContent()
                    
                    makePlayersList()
                }
                .padding(.horizontal, 16)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.medium)
                            
                            Text("Retour")
                        }
                        .foregroundStyle(.white)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("Valider")
                        }
                        .disabled(gameVM.areAllPlayersSelected())
                        .foregroundStyle(gameVM.areAllPlayersSelected() ? .accent : .lightNeutral)
                    }
                }
            }
            .background(.dark)
        }
        .navigationTitle("Liste des joueurs")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

extension SelectPlayersView {
    func makeTopContent() -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 20))
                
                Text(gameVM.areAllPlayersSelected() ? "Vous pouvez confirmer le match !" : "Tu dois sélectionner \(gameVM.getNumberOfPlayersRemainingToSelect()) joueurs")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Rechercher une personne", text: $search)
            }
            .padding()
            .background(.neutral)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.vertical, 14)
        .foregroundStyle(.white)
    }
    
    func makePlayer(name: String, isChecked: Bool) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
            
            VStack(alignment: .leading){
                Text(name)
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
            ForEach(players, id: \.self) { p in
                makePlayer(name: p, isChecked: gameVM.playersId.contains(p))
                    .onTapGesture {
                        if let index = gameVM.playersId.firstIndex(of: p) {
                            gameVM.removePlayer(index: index)
                        } else {
                            gameVM.addPlayer(playerId: p)
                        }
                    }
            }
        }
    }
}
