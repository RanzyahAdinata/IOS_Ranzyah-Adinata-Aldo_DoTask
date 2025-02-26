//
//  UserViewModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 26/02/25.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)

            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text(viewModel.selectedUser?.name ?? "Anonymous")
                    .font(.title2)
                    .bold()
                    .padding(.top, 5)

                Text(viewModel.selectedUser?.email ?? "anonymous@gmail.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
            .onAppear {
                viewModel.fetchUsers()
            }

            VStack(spacing: 15) {
                if let user = viewModel.selectedUser, user.name != "Anonymous" {
                        NavigationLink(destination: UserEditView(user: user)) {
                            userOptionButton(title: "Edit Profile", icon: "pencil")
                        }
                    } else {
                        userOptionButton(title: "Edit Profile", icon: "pencil")
                            .opacity(0.5)
                            .disabled(true) 
                    }

                NavigationLink(destination: UserCreateView()) {
                    userOptionButton(title: "Create Account", icon: "person.badge.plus")
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            VStack(alignment: .leading) {
                Text("Your Account")
                    .font(.headline)
                    .bold()
                    .padding(.leading, 20)

                ForEach(viewModel.users.filter { $0.id != viewModel.selectedUser?.id }, id: \User.id) { user in
                    accountRow(user: user) {
                        viewModel.changeUser(to: user)
                    }
                }
            }
            .padding(.bottom, 20)

            Button(action: {
                showAlert = true
            }) {
                Text("Delete Account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Apakah kamu yakin ingin menghapus akun ini?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteUser()
                    },
                    secondaryButton: .cancel()
                )
            }

            Spacer()

            HStack (spacing: 80) {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.top,20)
            .background(Color(UIColor.systemGray6))
        }
        .padding(.top, 20)
        .navigationBarBackButtonHidden(true)
    }

    private func userOptionButton(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }

    private func accountRow(user: User, action: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .bold()
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: action) {
                Text("Change")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(10)
    }
}

#Preview {
    UserView()
}
