//
//  TestApp.swift
//  Test
//
//  Created by Oleksandr on 30.10.2024.
//

import SwiftUI

@main
struct TestApp: App {
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject var aggregateViewModel = AggregateViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(aggregateViewModel)
                .environmentObject(networkMonitor)
        }
    }
}
