//
//  ContentView.swift
//  Test
//
//  Created by Oleksandr on 30.10.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var aggregateViewModel: AggregateViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        TabsView()
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AggregateViewModel())
        .environmentObject(NetworkMonitor())
}
