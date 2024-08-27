//
//  TransformDate.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation

func transformDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    
    return ""
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.locale = Locale(identifier: "fr_FR")
    return formatter.string(from: date)
}

func formatDateString(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    let outputFormatter = DateFormatter()
    outputFormatter.dateStyle = .medium
    outputFormatter.timeStyle = .short
    outputFormatter.locale = Locale(identifier: "fr_FR")
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    
    return ""
}

func formatDayString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter.string(from: date)
}

func formatTimeString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

func extractDay(from dateString: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = dateFormatter.date(from: dateString) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d MMM yyyy"
        dayFormatter.locale = Locale(identifier: "fr_FR")
        
        let formattedDate = dayFormatter.string(from: date)
        
        let components = formattedDate.components(separatedBy: " ")
        if components.count == 3,
           let month = components[1].first?.uppercased() {
            return "\(components[0]) \(month + components[1].dropFirst().lowercased()) \(components[2])"
        }
        
        return formattedDate
    }
    return "Date inconnue"
}

func extractTime(from dateString: String) -> String {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    if let date = dateFormatter.date(from: dateString) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
    return "Heure inconnue"
}
