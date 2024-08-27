//
//  HomeView.swift
//  dip-ios
//
//  Created by Alex ツ on 17/07/2024.


import SwiftUI
import SDWebImageSwiftUI
import SwiftEntryKit

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
    @State private var showProfileView = false
    @State private var showMatchResults = false
    @ObservedObject private var currentUser = CurrentUserService.shared
    @StateObject private var homeVM = HomeViewModel()
    
    init() {
        let apparence = UINavigationBarAppearance()
        apparence.configureWithOpaqueBackground()
        apparence.backgroundColor = .neutral
        UINavigationBar.appearance().standardAppearance = apparence
        UINavigationBar.appearance().scrollEdgeAppearance = apparence
    }
    
    var body: some View {
        ZStack {
            if showProfileView {
                ProfileView()
                    .transition(.move(edge: .bottom))
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        makeHeader()
                        
                        VStack(spacing: 24) {
                            if MatchManager.shared.matches?.finished != [] || MatchManager.shared.matches?.upcoming != [] {
                                if MatchManager.shared.matches?.upcoming != [] {
                                    makeMatchesSection(homeSheetEnum: .upcomming)
                                }
                                
                                if MatchManager.shared.matches?.finished != [] {
                                    makeMatchesSection(homeSheetEnum: .finished)
                                }
                            } else {
                                Text("Aucun match à afficher")
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    .background()
                }
                .refreshable {
                    homeVM.refresh()
                    SwiftEntryKit.showAlertMessage(message: "Refreshing")
                }
                .ignoresSafeArea(edges: .top)
                
                makeNewMatchButton()
            }
        }
        .onAppear {
            homeVM.refresh()
        }
        .onDisappear {
            showProfileView = false
        }
        .sheet(isPresented: $isNewMatchSheetPresented, content: {
            CreateMatchView()
        })
        .sheet(item: $showHomeSheet) { item in
            switch item {
            case .finished, .upcomming:
                MatchesView(homeVM: homeVM, homeSheetEnum: item)
            }
        }
        .sheet(isPresented: $showMatchResults) {
            MatchResultsSheet(homeVM: homeVM ,match: homeVM.selectedMatch!)
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
                Text("Bonjour \(currentUser.currentUser?.firstname ?? "")")
                
                Spacer()
                
                Button {
                    withAnimation {
                        showProfileView = true
                    }
                } label: {
                    WebImage(url: URL(string: homeVM.logo))
                        .resizable()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(lineWidth: 1)
                        }
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
                    
                    ForEach(((homeSheetEnum == .upcomming ? homeVM.matches?.upcoming.reversed() : homeVM.matches?.finished.reversed()) ?? [])) { m in
                        MatchCard(match: m)
                            .frame(width: 250)
                            .padding(.trailing, 20)
                            .onTapGesture {
                                homeVM.selectMatch(match: m)
                                showMatchResults.toggle()
                            }
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
