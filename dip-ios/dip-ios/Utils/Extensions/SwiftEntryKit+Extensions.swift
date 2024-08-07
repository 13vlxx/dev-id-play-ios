//
//  SwiftEntryKit+Extensions.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation
import SwiftEntryKit
import SwiftUI

extension SwiftEntryKit {
    
    static func showAlertMessage(message: String, duration: Double? = nil) {
        
        DispatchQueue.main.async {
            
            var attributes = EKAttributes.topNote
            
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .none
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: .standardBackground)
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            
            if let duration = duration {
                attributes.displayDuration = duration
            }
            
            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15), color: .standardContent, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)
            
            let contentView = EKNoteMessageView(with: labelContent)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    static func showSuccessMessage(message: String) {
        showNote(message, backgroundColor: UIColor(Color(.green)), fontColor: UIColor(Color.white))
//        DispatchQueue.main.async {
//
//            var attributes = EKAttributes.topNote
//
//            attributes.name = "Top Note"
//            attributes.hapticFeedbackType = .success
//            attributes.popBehavior = .animated(animation: .translation)
//            attributes.entryBackground = .color(color: .init(UIColor(red:0.315, green:0.783, blue:0.473, alpha:1.000)))
//            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
//            attributes.statusBar = .light
//
//            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15), color: .white, alignment: .center)
//            let labelContent = EKProperty.LabelContent(text: message, style: style)
//
//            let contentView = EKNoteMessageView(with: labelContent)
//
//            SwiftEntryKit.display(entry: contentView, using: attributes)
//        }
    }
    
    static func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            
            var attributes = EKAttributes.topNote
            
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.error
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: .init(.red))
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            
            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 16, weight: .semibold), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)
            
            let contentView = EKNoteMessageView(with: labelContent)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    static func showLoading(_ message: String) {
        DispatchQueue.main.async {
            var attributes = EKAttributes.topFloat
            
            attributes.name = "loadingNote"
            attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.none
            attributes.popBehavior = .animated(animation: .translation)
            attributes.displayDuration = .infinity
            
            attributes.entryBackground = .color(color: .init(.white))
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
            
            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15), color: .init(.blue), alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)
            
            let contentView = EKProcessingNoteMessageView(with: labelContent, activityIndicator: .medium)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    static private func showNote(_ message: String, backgroundColor: UIColor, fontColor: UIColor = .white, isInfiniteDuration: Bool = false, isSwipable: Bool = true, duration: Double? = nil) {
        DispatchQueue.main.async {
            var attributes = EKAttributes.topFloat

            attributes.name = "loadingNote"
            attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.none
            attributes.popBehavior = .animated(animation: .translation)
            if isInfiniteDuration {
                attributes.displayDuration = .infinity
            }
            if duration != nil {
                attributes.displayDuration = duration!
            }

            attributes.entryBackground = .color(color: .init(backgroundColor))
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            attributes.scroll = .enabled(swipeable: isSwipable, pullbackAnimation: .jolt)

            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15, weight: .bold), color: .init(fontColor), alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)

            let contentView = EKNoteMessageView(with: labelContent)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
}




