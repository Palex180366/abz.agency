//
//  InternetConnectionView.swift
//  Test
//
//  Created by Oleksandr on 05.11.2024.
//

import SwiftUI


struct NoInternetConnectionView: View {
    
    @EnvironmentObject var aggregateViewModel: AggregateViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Image(.noInternet)
            Text("There is no internet connection")
                .frame(width: 276, height: 24, alignment: .center)
                .font(Font.custom("Nunito Sans", size: 20))
                .padding()
            Button("Try again") {
                print("Button pressed!")
                Task {
                    // if the Internet came back
                    if networkMonitor.isConnected == true {
                        print("networkMonitor.isConnected == true")
                        //  you can make a GET request
                        do{
                            // I set it to the first page to start from the first page, not the one the user stopped on when scrolling through the list.
                            aggregateViewModel.networkManager.page = 1
                            //GET request
                            aggregateViewModel.usersType = try await
                            //generic method
                            aggregateViewModel.networkManager.getRequest(url: URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(aggregateViewModel.networkManager.page)&count=\(aggregateViewModel.networkManager.count)"), responseType: Users.self)
                            // fill the array with users
                            aggregateViewModel.usersDataSource.users = aggregateViewModel.usersType.users
                            // Users are sorted by registration date (the newest ﬁrst)
                            aggregateViewModel.usersDataSource.users.sort {
                                ($0.registrationTimestamp > $1.registrationTimestamp) }
                        } catch {
                            
                            print(String(describing: error))
                        }
                        // and close NoInternetConnectionView
                        dismiss()
                    }
                }//Task
                
            }
            .buttonStyle(TryAgainButton())
        }
    }
    
}

struct TryAgainButton: ButtonStyle {
    
    // @ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            .background(Color.colorBG)
            .foregroundStyle(.primary)
            .cornerRadius(24)
            .frame(maxWidth: 140, minHeight: 48)
        
    }
}

