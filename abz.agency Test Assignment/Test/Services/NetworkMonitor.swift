//
//  NetworkMonitor.swift
//  Test
//
//  Created by Oleksandr on 05.11.2024.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published var isConnected: Bool = true
    @Published var isPresented: Bool = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async{
                if path.status == .satisfied {
                    self.isConnected = true
                } else {
                    self.isConnected = false
                    self.isPresented = true
                    
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
