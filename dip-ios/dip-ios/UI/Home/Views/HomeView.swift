//
//  HomeView.swift
//  dip-ios
//
//  Created by Alex ツ on 17/07/2024.


import SwiftUI

enum HomeSheetEnum: Identifiable {
    var id: Self {
        return self
    }
    
    case upcomming
    case finished
    
    func getTitle() -> String {
        switch self {
        case .upcomming:
            return "Parties à venir"
        case .finished:
            return "Parties terminées"
        }
    }
}

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isNewMatchSheetPresented = false
    @State private var showHomeSheet: HomeSheetEnum?
    @State private var isProfileSheetPresented = false
    
    init() {
        let apparence = UINavigationBarAppearance()
        apparence.configureWithOpaqueBackground()
        apparence.backgroundColor = .neutral
        UINavigationBar.appearance().standardAppearance = apparence
        UINavigationBar.appearance().scrollEdgeAppearance = apparence
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    makeHeader()
                    
                    VStack(spacing: 24) {
                        makeMatchesSection(homeSheetEnum: .upcomming)
                        
                        makeMatchesSection(homeSheetEnum: .finished)
                    }
                    .padding(.bottom, 80)
                }
                .background()
            }
            .ignoresSafeArea(edges: .top)
            
            makeNewMatchButton()
        }
        .sheet(isPresented: $isNewMatchSheetPresented, content: {
            CreateMatchView()
        })
        .sheet(isPresented: $isProfileSheetPresented, content: {
            Button("logout") {
                CurrentUserService.shared.logout()
            }
        })
        .sheet(item: $showHomeSheet) { item in
            switch item {
            case .finished, .upcomming:
                MatchesView(homeSheetEnum: item)
            }
        }
    }
}

extension HomeView {
    func makeHeader() -> some View {
        ZStack {
            GeometryReader { g in
                Image("RulePicture")
                    .resizable()
                    .scaledToFill()
                    .frame(height: g.frame(in: .global).minY > 0 ? 200 + g.frame(in: .global).minY : 200)
                    .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
            }
            .frame(height: 200)
            
            HStack {
                Text("Bonjour Alex")
                
                Spacer()
                
                Image(systemName: "circle")
                    .onTapGesture {
                        isProfileSheetPresented = true
                    }
            }
            .font(.system(size: 30))
            .fontWeight(.bold)
            .padding(.horizontal)
        }
        
    }
    
    func makeMatchesSection(homeSheetEnum: HomeSheetEnum) -> some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(homeSheetEnum.getTitle())
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    showHomeSheet = homeSheetEnum
                } label: {
                    Text("Voir tout")
                        .font(.system(size: 16))
                        .foregroundStyle(.content)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 20)
                    
                    ForEach(0..<5) { _ in
                        MatchCard(type: MatchCardStatus.normal, gameName: "Uno")
                            .frame(width: 250)
                            .padding(.trailing, 20)
                    }
                }
            }
            .listRowInsets(EdgeInsets())
        }
    }
    
    func makeNewMatchButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                isNewMatchSheetPresented.toggle()
            } label: {
                HStack {
                    Image(systemName: "play.circle.fill")
                    
                    Text("Créer une nouvelle partie")
                }
                .font(.system(size: 18))
                .fontWeight(.bold)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color(.accent))
                .foregroundStyle(Color(.content))
            }
        }
    }
}

#Preview {
    HomeView()
}
