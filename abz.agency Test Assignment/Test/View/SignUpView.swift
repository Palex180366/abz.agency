////
////  SignUpView.swift
////  Test
////
////  Created by Oleksandr on 05.11.2024.
////
//
import SwiftUI
import UIKit
import Photos
import PhotosUI

struct SignUpView: View {
    
    @EnvironmentObject var aggregateViewModel: AggregateViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @State var showAlert = false
    @State var networkError = ""
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isPhotoUploaded: Bool = false // if the photo is uploaded
    @State private var selectedImage: UIImage? // Stores the selected image
    @State private var imagePath: String? // Stores the path to the image
    @State private var isPickerPresented = false // Indicates whether the picker is displayed
    @State private var nameError: String?
    @State private var emailError: String?
    @State private var phoneError: String?
    @State private var photoError: String?
    
    @State private var selectedUserPosition: String = "Lawyer"
    @State private var positionID: Int = 1
    
    var userPositions = ["Lawyer", "Content manager", "Security", "Designer"]
    
    @State var isUserRegistered = false
    @State var isUserExist = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        VStack() {
            Text("Working with POST request")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 56)
                .font(Font.custom("Nunito Sans", size: 20))
                .background(Color.colorBG)
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            
            VStack {
                ScrollView {
                    // TextFields
                    Group {
                        // Your name
                        VStack(alignment: .leading, spacing: 5) {
                            TextField("Your name", text: $name)
                                .focused($isTextFieldFocused)
                                .frame(maxWidth: .infinity)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(nameError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                            if let nameError = nameError {
                                Text(nameError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 5) {
                            TextField("Email", text: $email)
                                .focused($isTextFieldFocused)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(emailError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                            if let emailError = emailError {
                                Text(emailError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Phone
                        VStack(alignment: .leading, spacing: 5) {
                            TextField("Phone +38 (xxx) xxx-xx-xx", text: $phone)
                                .focused($isTextFieldFocused)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(phoneError == nil ? Color.clear : Color.red, lineWidth: 1)
                                )
                            if let phoneError = phoneError {
                                Text(phoneError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                    // Select your position (Radio Button)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select your position")
                            .frame(width: 262, height: 24, alignment: .leading)
                            .font(.subheadline)
                        
                        ForEach(userPositions, id: \.self) { position in
                            HStack {
                                RadioButton(isSelected: selectedUserPosition == position) {
                                    selectedUserPosition = position
                                    switch selectedUserPosition {
                                    case "Lawyer":
                                        self.positionID = 1
                                        print("\(positionID)")
                                    case "Content manager":
                                        self.positionID = 2
                                        print("\(positionID)")
                                    case "Security":
                                        self.positionID = 3
                                        print("\(positionID)")
                                    case "Designer":
                                        self.positionID = 4
                                        print("\(positionID)")
                                    default:
                                        self.positionID = 1
                                    }
                                }
                                Text(position)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                    
                    // photo
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Upload your photo")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            // Upload
                            Button("Upload") {
                                self.isPickerPresented = true
                                
                                // Photo upload action
                                isPhotoUploaded.toggle()
                                photoError = isPhotoUploaded ? nil : "Photo is required"
                            }
                            .focused($isTextFieldFocused)
                            .foregroundColor(.blue)
                        }
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(photoError == nil ? Color.clear : Color.red, lineWidth: 1)
                            
                        )
                        if let photoError = photoError {
                            Text(photoError)
                                .font(.caption)
                                .foregroundColor(.red)
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sign up Button
                    Button(action: {
                        validateFields()
                        print("Sign up Button tap")
                        isTextFieldFocused = false
                        Task {
                            do{
                                
                                try await  aggregateViewModel.networkManager.uploadUserData(user: User(name: name, email: email, phone: phone, position: selectedUserPosition, positionID: positionID, photo: imagePath ?? "person.circle.fill"), token: aggregateViewModel.networkManager.getToken()) { message in
                                    print("response: \(message)")
                                    // switching flags for different messages
                                    switch message {
                                    case "New user successfully registered":
                                        isUserRegistered = true
                                    case "User with this phone or email already exist":
                                        isUserExist = true
                                    default:
                                        break
                                    }
                                }
                                
                                // catch custom error
                            } catch let error as NetworkError {
                                self.networkError = error.localizedDescription
                                // showAlert = true
                                print(error.localizedDescription) // ⚠️
                                print(String(describing: error)) // ✅
                                // catch system error
                            }  catch {
                                self.networkError = error.localizedDescription
                                //  showAlert = true
                                print(error.localizedDescription) // ⚠️
                                print(String(describing: error)) // ✅
                                
                            }
                        }
                    }) {
                        Text("Sign up")
                    }
                    .focused($isTextFieldFocused)
                    .buttonStyle(SingUpButton())
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                    
                    Spacer()
                }//Scroll
                .onTapGesture {
                    isTextFieldFocused = false
                }
                
            }
            .padding(.top, 20)
        }
        
        // display Photo picker
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImage: $selectedImage, imagePath: $imagePath)
        }
        // display UserRegisteredView
        .fullScreenCover(isPresented: $isUserRegistered, content: UserRegisteredView.init)
        // display EmailRegisteredView
        .fullScreenCover(isPresented: $isUserExist, content: EmailRegisteredView.init)
    }// body
    
    // check if the fields are filled in
    private func validateFields() {
        nameError = name.isEmpty ? "Required field" : nil
        emailError = email.isEmpty ? "Required field" : (!isValidEmail(email) ? "Invalid email format" : nil)
        //  phoneError = phone.isEmpty ? "Required field" : (!isValidPhoneNumber(phone)  ? "Invalid phone number format" : nil)
        phoneError = phone.isEmpty ? "Required field" : nil
        photoError = isPhotoUploaded ? nil : "Photo is required"
    }
    
    // checking that the mail complies with certain rules
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // checking whether the phone number complies with certain rules
    //    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
    //        // Regular expression
    //       let phoneRegex = "^\\+38 \\(\\d{3}\\) \\d{3}-\\d{2}-\\d{2}$"
    //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    //        return phoneTest.evaluate(with: phoneNumber)
    //    }
    
    
}

// Radio button
struct RadioButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .strokeBorder(Color.blue, lineWidth: 2)
                .background(Circle().fill(isSelected ? Color.blue : Color.clear))
                .frame(width: 20, height: 20)
        }
    }
}

// Previews
struct SignUpViews_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AggregateViewModel())
            .environmentObject(NetworkMonitor())
    }
}

// style of  "Sing up" button
struct SingUpButton: ButtonStyle {
    
    //@ViewBuilder
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
            .background(Color.colorBG)
            .foregroundStyle(.primary)
            .cornerRadius(24)
            .frame(maxWidth: 140, minHeight: 48)
    }
}

