//
//  EmailRegisteredView.swift
//  Test
//
//  Created by Oleksandr on 02.01.2025.
//

import SwiftUI

struct EmailRegisteredView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Spacer()
        VStack(alignment: .center, spacing: 10) {
            Image(.emailRegistered)
            Text("That email is already registered")
                .frame(width: 280, height: 24, alignment: .center)
                .font(Font.custom("Nunito Sans", size: 20))
                .padding()
            
            Button("Try again") {
                print("Button pressed!")
                
                dismiss()
            }
            .buttonStyle(TryAgainButton())
            
        }
        Spacer()
    }
}

#Preview {
    EmailRegisteredView()
}
