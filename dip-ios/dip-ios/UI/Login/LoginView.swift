//
//  LoginView.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var isLoading = false
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        ScrollView {
            GeometryReader {g in
                Image("LoginPicture")
                    .resizable()
                    .scaledToFill()
                    .frame(height: g.frame(in: .global).minY > 0 ? 500 + g.frame(in: .global).minY : 500)
                    .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
            }
            .frame(height: 500)
            
            VStack(spacing: 24) {
                HStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                    (Text("Dev-id ") + Text("Play")
                        .foregroundStyle(.accent)
                    )
                    .fontWeight(.bold)
                    .font(.system(size: (54)))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Connexion")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    
                    Text("Prêt à jouer  ? Connectes-toi dès maintenant !")
                        .font(.system(size: 16))
                }
                
                Button {
                    isLoading = true
                    OAuthManager.shared.authenticate { accessToken, refreshToken in
                        if let accessToken = accessToken {
                            loginVM.login(accessToken)
                        }
                    }
                    isLoading = false
                } label: {
                    HStack(spacing: 30) {
                        Image("GoogleLogo")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("Connexion avec Google")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.dark)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .foregroundStyle(.content)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dark)
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}

