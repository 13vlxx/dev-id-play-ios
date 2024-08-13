//
//  HomeViewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 06/08/2024.
//

import Foundation

class HomeViewModel: BaseViewModel {
    @Published var logo: String
    @Published var matches: GetUserDashboard?
    @Published var selectedMatch: Match?
    @Published var winnersId = [String]()
    
    override init() {
        self.logo = CurrentUserService.shared.currentUser?.logoUrl ?? ""
        self.matches = MatchManager.shared.matches
    }
    
    func selectMatch(match: Match) {
        selectedMatch = match
    }
    
    func addWinner(playerId: String) {
        self.winnersId.append(playerId)
    }
    
    func removeWinner(index: Int) {
        self.winnersId.remove(at: index)
    }
    
    func updateWinners(callback: @escaping (Bool) -> Void) {
        WebService
            .putUpdateMatch(
                matchId: selectedMatch!.id,
                updateMatchDto: UpdateMatchDto(status: .finished, winners: winnersId.count > 0 ? winnersId : nil)
            ) { isSuccess in
                if isSuccess {
                    callback(isSuccess)
                    self.refresh()
                }
            }
    }
    
    func refresh() {
        MatchManager.shared.fetchMatches {
            self.matches = MatchManager.shared.matches
        }
    }
}
