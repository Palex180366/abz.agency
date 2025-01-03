//
//  NoUsersView.swift
//  Test
//
//  Created by Oleksandr on 27.11.2024.
//

import SwiftUI
import UIKit

struct NoUsersView: View {
    
    var body: some View {
        
        Spacer()
        VStack(alignment: .center, spacing: 10) {
            Image(.noUsers)
            Text("There are no users yet")
                .frame(width: 220, height: 24, alignment: .center)
                .font(Font.custom("Nunito Sans", size: 20))
                .padding()
        }
        Spacer()
    }
}

#Preview {
    NoUsersView()
}
