//
//  ModalManager.swift
//  dip-ios
//
//  Created by Alex ツ on 07/08/2024.
//

import Foundation

class ModalManager: ObservableObject {
    static let shared = ModalManager()
    
    @Published var showProfileFSC = false
    
    func clear() {
        showProfileFSC = false
    }
}
