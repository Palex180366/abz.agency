//
//  UsersView.swift
//  Test
//
//  Created by Oleksandr on 05.11.2024.
//

import SwiftUI

struct UsersView: View {
    
    @EnvironmentObject var aggregateViewModel: AggregateViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var showAlert = false
    @State var networkError = ""
    @State var isUsersArrayEmpty = true
    @State var isShowLoader : Bool = false
    
    var body: some View {
        
        VStack {
            Text("Working with GET request")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 56)
                .font(Font.custom("Nunito Sans", size: 20))
                .background(Color.colorBG)
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            
            VStack {
                if isUsersArrayEmpty == false {
                    List {
                        ForEach(aggregateViewModel.usersDataSource.users, id:  \.self) { user in
                            CardView(user: user)
                                .onAppear {
                                    
                                    // Pagination
                                    //check when the last User in the table (List) corresponds to the last User in the data array (users)
                                    if user.id == aggregateViewModel.usersDataSource.users.last?.id {// after their id matches:
                                        // page increasing  by 1
                                        aggregateViewModel.networkManager.page += 1
                                        
                                        print("Loading.............page: \(aggregateViewModel.networkManager.page)")
                                        // and run the code to retrieve six users for the next page.
                                        Task {
                                            do{
                                                isShowLoader = true// activity view
                                                
                                                //
                                                //GET request
                                                aggregateViewModel.usersType = try await
                                                //generic method
                                                aggregateViewModel.networkManager.getRequest(url: URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(aggregateViewModel.networkManager.page)&count=\(aggregateViewModel.networkManager.count)"), responseType: Users.self)
                                                // fill the array with 6 users
                                                aggregateViewModel.usersDataSource.users .append(contentsOf: aggregateViewModel.usersType.users)
                                                
                                                aggregateViewModel.usersDataSource.users.sort {
                                                    ($0.registrationTimestamp > $1.registrationTimestamp) }
                                                // after each page loads, disable activity view
                                                isShowLoader = false// activity view
                                                
                                            } catch {
                                                self.networkError = error.localizedDescription
                                                //  showAlert = true
                                                print(error.localizedDescription) // ⚠️
                                                print("End page")
                                                //after loading the last page, disable activity view
                                                isShowLoader = false
                                            }
                                        }//Task
                                    }
                                }//onAppear
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                } else {
                    NoUsersView()
                }
                //activity view
                if isShowLoader {
                    progressView(isShowLoader: isShowLoader)
                }
            }
        }
        
        
        .onAppear {
            
            Task {
                do{
                    //GET request
                    aggregateViewModel.usersType = try await
                    //generic method
                    aggregateViewModel.networkManager.getRequest(url: URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(aggregateViewModel.networkManager.page)&count=\(aggregateViewModel.networkManager.count)"), responseType: Users.self)
                    // fill the array with users
                    aggregateViewModel.usersDataSource.users = aggregateViewModel.usersType.users
                    // Users are sorted by registration date (the newest ﬁrst)
                    aggregateViewModel.usersDataSource.users.sort {
                        ($0.registrationTimestamp > $1.registrationTimestamp) }
                    // if users array is isEmpty,
                    if !aggregateViewModel.usersDataSource.users.isEmpty {
                        // set true that appear NoUsersView
                        isUsersArrayEmpty = false//true
                        
                    }
                    
                    // catch custom error
                } catch let error as NetworkError {
                    self.networkError = error.localizedDescription
                    //  showAlert = true
                    print(error.localizedDescription) // ⚠️
                    print(String(describing: error)) // ✅
                    // catch system error
                }  catch {
                    self.networkError = error.localizedDescription
                    //  showAlert = true
                    print(error.localizedDescription) // ⚠️
                    print(String(describing: error)) // ✅
                    
                }
            }//Task
        }//onAppear
        
        .onDisappear {
            // set to the first page to start from the first page, not the one the user stopped on when scrolling through the list.
            aggregateViewModel.networkManager.page = 1
        }// onDisappear
        
        // displays errors
        .alert("Error message", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("\(self.networkError)")
        }
        
        // show NoInternetConnectionView, when there is no internet available
        .fullScreenCover(isPresented: $networkMonitor.isPresented, content: NoInternetConnectionView.init)
        
    }
}

#Preview {
    UsersView()
        .environmentObject(AggregateViewModel())
        .environmentObject(NetworkMonitor())
}


// activity view
@ViewBuilder
func progressView(isShowLoader: Bool) -> some View {
    ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .black))
        .scaleEffect(2.0, anchor: .center)
}
