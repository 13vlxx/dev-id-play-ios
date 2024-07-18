//
//  RuleView.swift
//  dip-ios
//
//  Created by Alex ツ on 16/07/2024.
//

import SwiftUI
import MessageUI

struct RuleView: View {
    @State private var isShowingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    
    let rule1 = Rule(id: 0, points: 1, description: "gagné pour chaque participation à un match")
    let rule2 = Rule(id: 1, points: 10, description: "pour celui ou celle qui gagne un match")
    let rule3 = Rule(id: 2, points: 25, description: "pour celui ou celle qui a eu les plus d’adversaires différents sur la semaine")
    let rule4 = Rule(id: 3, points: 50, description: "pour celui ou celle qui a eu le plus de parties sur des jeux différents sur le mois")
    let rule5 = Rule(id: 4, description: "Une fois un match terminé, il n’est plus possible de jouer contre l’adversaire jusqu’à la semaine suivante.")
    let rule6 = Rule(id: 5, description: "Remise à zéro des adversaires tous les lundis et remise des scores chaque 1er du mois.")
    let rule7 = Rule(id: 6, description: "En cas d’ex-aequo c’est Random.org qui tranchera")
    var rules: [Rule] {
        return [rule1, rule2, rule3, rule4, rule5, rule6, rule7]
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                Image("RulePicture")
                
                Text("Règles")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
            }
            ScrollView {
                ForEach(rules) { rule in
                    RuleItem(rule: rule)
                }
                .font(.system(size: 13))
            }
            .padding(.horizontal)
            
            Button(action: {
                print("Email")
            }, label: {
                HStack {
                    Image(systemName: "lightbulb.fill")
                    
                    Text("J'ai une idée de jeu")
                }
                .font(.system(size: 18))
                .fontWeight(.bold)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(.accent)
                .foregroundStyle(Color(.content))
                .sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$mailResult)
                }
            })
        }
        .background(Color.dark)
        .ignoresSafeArea(edges: .top)
    }
}

    struct MailView: UIViewControllerRepresentable {
        @Environment(\.presentationMode) var presentation
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
            @Binding var isShowing: Bool
            @Binding var result: Result<MFMailComposeResult, Error>?

            init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
                _isShowing = isShowing
                _result = result
            }

            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                defer {
                    isShowing = false
                }
                if let error = error {
                    self.result = .failure(error)
                } else {
                    self.result = .success(result)
                }
                controller.dismiss(animated: true)
            }
        }

        func makeCoordinator() -> Coordinator {
            return Coordinator(isShowing: $isShowing, result: $result)
        }

        func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = context.coordinator
            // Configure the fields of the interface.
            // For example, to set the subject:
            // vc.setSubject("Hello!")
            // To set the recipients:
            // vc.setToRecipients(["example@example.com"])
            return vc
        }

        func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
            // No update needed
        }
    }


#Preview {
    RuleView()
}
