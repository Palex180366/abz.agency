//
//  NetworkManager.swift
//  Test
//
//  Created by Oleksandr on 20.11.2024.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .invalidResponse:
            return "Invalid response from the server."
        case .invalidData:
            return "The data received from the server is invalid."
        }
    }
}

class NetworkManager: ObservableObject {
    
    var page = 1
    var count = 6
    @Published var isUserRegistered = false
    @Published var isUserExist = false
    
    
    // GET method (Generic)
    func getRequest<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T {
        
        guard let url = url else { throw NetworkError.invalidURL }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw NetworkError.invalidData
        }
        
    }
    
    // GET token
    func getToken() async throws -> String {
        //https://frontend-test-assignment-api.abz.agency/api/v1/token
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/token".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw NetworkError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        let decodedData = try JSONDecoder().decode(Token.self, from: data)
        let token = decodedData.token
        print("token success: \(String(describing: decodedData.success!))")
        
        return token
    }
    
    // POST method
    func uploadUserData(user: User, token: String, completion:  @escaping (_ responseMessage: String) -> Void) {
        
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users") else { return }
        
        // Create a request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("\(token)", forHTTPHeaderField: "Token")
        
        // Create a body request
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add text parameters
        let params: [String: String] = [
            "name": user.name,
            "email": user.email,
            "phone": user.phone,
            "position_id": String(user.positionID)
        ]
        
        for (key, value) in params {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // Adding an image file
        if let image = UIImage(contentsOfFile: user.photo), // Load the image on the path from the string
           let imageData = image.jpegData(compressionQuality: 0.8) { // Convert to Data
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        } else {
            print("Error: Failed to load image at path \(user.photo)")
            return
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        // Sending a request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            //
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                if let jsonData = responseString.data(using: .utf8) {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            print("JSON: \(jsonObject)")
                            if let message = jsonObject["message"] as? String {
                                // print("Message: \(message)")
                                completion(message)
                            }
                        }
                    } catch {
                        print("JSON parcing error: \(error.localizedDescription)")
                    }
                }
            }
        }
        task.resume()
    }
    
}

//GET request
//all users
//https://frontend-test-assignment-api.abz.agency/api/v1/users?page=1&count=6
// specific "user_id": 25525
//https://frontend-test-assignment-api.abz.agency/api/v1/users/25525

//POST request
//https://frontend-test-assignment-api.abz.agency/api/v1/users

// Extension for easy addition of strings to Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
