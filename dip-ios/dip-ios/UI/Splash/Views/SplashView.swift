//
//  SplashView.swift
//  dip-ios
//
//  Created by Alex ツ on 06/08/2024.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var splashVM: SplashViewModel
    @State private var showAnimation = false
    
    var body: some View {
        ZStack {
            Color.accent
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image(.applogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: showAnimation ? 130 : 120)
                Text("Dev-ID Play")
                    .font(.system(size: 40, weight: .black, design: .serif))
                
                if showAnimation {
                    ProgressView()
                        .frame(height: 50)
                }
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                showAnimation = true
            }
            splashVM.fetchSplashData()
        }
    }
}
