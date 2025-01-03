//
//  AggregateViewModel.swift
//  Test
//
//  Created by Oleksandr on 20.11.2024.
//

import Foundation
import SwiftUI

class AggregateViewModel: ObservableObject {
    
    @Published var usersDataSource = UsersDataSource()
    @Published var networkManager = NetworkManager()
    @Published var usersType = Users()
    
}
