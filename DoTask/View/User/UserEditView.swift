//
//  UserEditView.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 26/02/25.
//

import SwiftUI

struct UserEditView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @StateObject private var viewModel = UserEditViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let user: User
    
        init(user: User) {
            self.user = user
            _username = State(initialValue: user.name)
            _email = State(initialValue: user.email)
        }

    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            Text("Edit Profile")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter new username", text: $username)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                
                Text("Email")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter new email", text: $email)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
            Button(action: {
                viewModel.updateUser(name: username, email: email) {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .onAppear {
            viewModel.loadUserData { name, email in
                self.username = name
                self.email = email
            }
        }
    }
}
