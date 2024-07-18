//
//  HomeView.swift
//  dip-ios
//
//  Created by Alex ツ on 17/07/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        Image("RulePicture")
                        
                        HStack {
                            Text("Bonjour Alex")
                            
                            Spacer()
                            
                            Image(systemName: "circle")
                        }
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 24) {
                        UpcommingMatchesSection(title: "Parties à venir")
                        
                        
                        UpcommingMatchesSection(title: "Parties terminées")
                    }
                }
                .background()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                
                Button(action: {
                    print("Email")
                }, label: {
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
                })
            }
        }
    }
}

#Preview {
    HomeView()
}
