//
//  UpcommingMatchesSection.swift
//  dip-ios
//
//  Created by Alex ツ on 17/07/2024.
//

import SwiftUI

struct UpcommingMatchesSection: View {
    var title: String
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(title)
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Voir tout")
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 20)
                        
                    ForEach(0..<2) { _ in
                        ZStack {
                            Image("UnoGame")
                                .resizable()
                        }
                        .frame(width: 250, height: 166)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.trailing, 20)
                    }
                }
            }
            .listRowInsets(EdgeInsets())
        }
    }
}

#Preview {
    UpcommingMatchesSection(title: "Parties à venir")
}
