//
//  RuleItem.swift
//  dip-ios
//
//  Created by Alex ツ on 16/07/2024.
//

import SwiftUI

struct RuleItem: View {
    var rule: Rule
    
    var body: some View {
        HStack {
                    if let points = rule.points {
                        Text("\(String(describing: points)) \(points == 1 ? "point" : points >= 25 ? "points bonus" : "points") ")
                            .foregroundStyle(.accent)
                        +
                        Text(rule.description)
                    } else {
                        Text(rule.description)
                    }
                }
        .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
                .background((rule.points != nil) ? Color(.neutral) : Color(.lightNeutral))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
}

#Preview {
    RuleItem(rule: Rule(id: 0, points: nil, description: "alex"))
}
