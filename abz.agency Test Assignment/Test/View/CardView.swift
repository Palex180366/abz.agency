//
//  CardView.swift
//  Test
//
//  Created by Oleksandr on 20.11.2024.
//

import SwiftUI
import UIKit

struct CardView: View {
    
    var user: User
    
    var body: some View {
        
        HStack(alignment: .top) {
            // get image
            AsyncImage(url: URL(string: user.photo)) { image in
                // image here
                image
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color(.systemGray4))
                    .clipShape(Circle())
            } placeholder: {
                // image placeholder here
                Image(uiImage: UIImage(systemName: "person.circle.fill")!)
                    .resizable()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color(.systemGray4))
                    .clipShape(Circle())
                
            }
            
            VStack(alignment: .leading) {
                // User name
                Text("\(String(describing: user.name))")
                    .font(Font.custom("Nunito Sans", size: 18))
                    .padding(.bottom, 4)
                
                // User position
                Text("\(String(describing: user.position))")
                    .frame(width: 262, height: 24, alignment: .leading)
                    .font(Font.custom("Nunito Sans", size: 14))
                    .padding(.bottom, 8)
                
                // User email
                Text("\(String(describing: user.email))")
                    .frame(width: 262, height: 24, alignment: .leading)
                    .font(Font.custom("Nunito Sans", size: 14))
                
                Text("\(String(describing: user.phone))")
                    .frame(width: 262, height: 24, alignment: .leading)
                    .font(Font.custom("Nunito Sans", size: 14))
                
                
            }
            .padding(.leading, 8)
        }
    }
    
}


