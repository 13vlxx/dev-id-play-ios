//
//  MatchesView.swift
//  dip-ios
//
//  Created by Alex ツ on 24/07/2024.
//

import SwiftUI

struct MatchesView: View {
    @Environment(\.dismiss) var dismiss
    let homeSheetEnum: HomeSheetEnum
    
    var body: some View {
        NavigationView {
            HStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: 20)
                        ForEach(MatchManager.shared.matches!.finished) { m in
                            MatchCard(type: .loose, match: m)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .background(Color(.dark))
            .navigationTitle(homeSheetEnum.getTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}
