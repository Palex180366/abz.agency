//
//  UserRegisteredView.swift
//  Test
//
//  Created by Oleksandr on 02.01.2025.
//

import SwiftUI

struct UserRegisteredView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        Spacer()
        VStack(alignment: .center, spacing: 10) {
            Image(.userRegistered)
            Text("User successfully registered")
                .frame(width: 260, height: 24, alignment: .center)
                .font(Font.custom("Nunito Sans", size: 20))
                .padding()
            
            Button("Got it") {
                print("Button pressed!")
                
                dismiss()
            }
            .buttonStyle(TryAgainButton())
            
        }
        Spacer()
    }
}

#Preview {
    UserRegisteredView()
}
