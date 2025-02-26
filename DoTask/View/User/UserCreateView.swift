//
//  UserCreateView.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 26/02/25.
//

import SwiftUI

struct UserCreateView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @StateObject private var viewModel = UserCreateViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            Text("Create Account")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter username", text: $username)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                
                Text("Email")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
            Button(action: {
                viewModel.createUser(name: username, email: email) {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

#Preview {
    UserCreateView()
}
