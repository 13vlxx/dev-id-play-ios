//
//  MatchesView.swift
//  dip-ios
//
//  Created by Alex ツ on 24/07/2024.
//

import SwiftUI

struct MatchesView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var homeVM: HomeViewModel
    @State private var showMatchResults = false
    let homeSheetEnum: HomeSheetEnum
    
    var body: some View {
        NavigationView {
            HStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: 20)
                        ForEach(homeSheetEnum == .finished ? MatchManager.shared.matches?.finished.reversed() ?? [] : MatchManager.shared.matches?.upcoming.reversed() ?? []) { m in
                            MatchCard(match: m)
                                .onTapGesture {
                                    homeVM.selectMatch(match: m)
                                    showMatchResults.toggle()
                                }
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
            .sheet(isPresented: $showMatchResults) {
                MatchResultsSheet(homeVM: homeVM ,match: homeVM.selectedMatch!)
            }
        }
    }
}
