//
//  User.swift
//  Test
//
//  Created by Oleksandr on 20.11.2024.
//

import Foundation

struct Users: Codable {
    var users = [User]()
}

// MARK: - User
struct User: Codable, Hashable,Identifiable {
    let id = UUID()
    let name, email, phone, position: String
    let positionID: Int
    let photo: String
    let registrationTimestamp: Int = 0
  

    enum CodingKeys: String, CodingKey {
        case name, email, phone, photo, position
        case positionID = "position_id"
        case registrationTimestamp = "registration_timestamp"

    }
}

struct Token: Codable {
    var success: Bool? 
    var token = ""
}
