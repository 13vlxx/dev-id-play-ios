//
//  BaseViewModel.swift
//  dip-ios
//
//  Created by Alex ツ on 15/07/2024.
//

import Foundation
import Combine

class BaseViewModel: NSObject, ObservableObject {
    @Published var isLoading = false
    
    internal var bag = Set<AnyCancellable>()
}
