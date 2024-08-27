//
//  ProfileView.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var currentUser = CurrentUserService.shared
    private let medals = ["bronze", "silver", "gold"]
    
    private func getNumberOfMedal(for medal: String) -> Int {
        switch medal {
        case "bronze":
            return Int(currentUser.currentUser?.medals.bronze ?? 0)
        case "silver":
            return Int(currentUser.currentUser?.medals.silver ?? 0)
        case "gold":
            return Int(currentUser.currentUser?.medals.gold ?? 0)
        default:
            return 0
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    makeHeader()
                    makeStats()
                    makeMedals()
                    makeLogoutButton()
                }
            }
        }
    }
}

extension ProfileView {
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
                Text("Profil")
                
                if let currentUser = currentUser.currentUser {
                    Text(currentUser.firstname + " " + currentUser.lastname)
                        .font(.system(size: 24, weight: .semibold))
                }
            }
            .font(.system(size: 30))
            .fontWeight(.bold)
            .padding(.horizontal)
            
        }
    }
    
    func makeStats() -> some View {
        VStack(alignment: .leading) {
            Text("Mois en cours")
                .font(.system(size: 20, weight: .semibold))
            HStack {
                VStack {
                    Text("Mes points")
                    
                    Text("\(Int(currentUser.currentUser?.stats?.points ?? 0))")
                        .opacity(0.6)
                }
                Spacer()
                VStack {
                    Text("Mon classement")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    ZStack {
                        Image(.badgeRanked)
                        if let rank = currentUser.currentUser?.stats?.rank {
                            VStack(spacing: 0) {
                                Text("\(Int(rank))")
                                    .font(.system(size: 24, weight: .semibold))
                                Text("\(rank == 1 ? "er" : "ème")")
                                    .font(.system(size: 12))
                            }
                        } else {
                            Text("0")
                        }
                    }
                }
                .multilineTextAlignment(.center)
                Spacer()
                VStack {
                    Text("Matchs joués")
                    
                    Text("\(Int(currentUser.currentUser?.stats?.matchesPlayed ?? 0))")
                        .opacity(0.6)
                }
            }
            .font(.system(size: 16))
            .padding(.vertical, 24)
            .padding(.horizontal, 12)
            .background(.neutral)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 20)
        .padding()
    }
    
    func makeMedals() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Médailles")
                .font(.system(size: 20, weight: .semibold))
            
            HStack {
                Text("Or")
                
                Spacer()
                
                Text("\(getNumberOfMedal(for: medals[2]))")
                    .foregroundStyle(.dark)
                    .fontWeight(.bold)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 20).fill(.yellow)
                    }
            }
            .font(.system(size: 16))
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            .background(.neutral)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            HStack {
                Text("Argent")
                
                Spacer()
                
                Text("\(getNumberOfMedal(for: medals[1]))")
                    .foregroundStyle(.dark)
                    .fontWeight(.bold)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 20).fill(.gray)
                    }
            }
            .font(.system(size: 16))
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            .background(.neutral)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            HStack {
                Text("Bronze")
                
                Spacer()
                
                Text("\(getNumberOfMedal(for: medals[0]))")
                    .foregroundStyle(.dark)
                    .fontWeight(.bold)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 20).fill(.brown)
                    }
            }
            .font(.system(size: 16))
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            .background(.neutral)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
    }
    
    func makeLogoutButton() -> some View {
        Button {
            currentUser.logout()
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                
                Text("Déconnexion")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 80)
            .background(.accent)
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .padding(.horizontal)
            .padding(.bottom, 28)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ProfileView()
}
