//
//  TabView.swift
//  Test
//
//  Created by Oleksandr on 05.11.2024.
//

import SwiftUI
import UIKit
struct TabsView: View {
    
    @State private var selection = 1
    @EnvironmentObject var aggregateViewModel: AggregateViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    
    var body: some View {
        
        ZStack {
            TabView(selection: $selection) {
                
                UsersView()
                    .tabItem {
                        Label("Users", systemImage: "person.3.sequence")
                    }
                    .tag(1)
                
                SignUpView()
                    .tabItem {
                        Label("Sign up", systemImage: "person.crop.circle.fill.badge.plus")
                    }
                    .tag(2)
                
            }
            .accentColor(.blue)// bar item color
            
            .onAppear {
                
                selection = 1
                UITabBar.appearance().backgroundColor = .systemGray6
                
            }
        }// ZStack
    }
}

#Preview {
    TabsView()
        .environmentObject(AggregateViewModel())
        .environmentObject(NetworkMonitor())
}
