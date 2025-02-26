//
//  UserViewModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 26/02/25.
//

import SwiftUI

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var selectedUser: User?
    
    private let apiURL = "https://67bd5803321b883e790c13f4.mockapi.io/dotask-api/users/users"
    private let userDefaultsKey = "selectedUserId"
    
    init() {
        fetchUsers()
    }

    func fetchUsers() {
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                    self.loadSelectedUser()
                }
            } catch {
                print("Failed to decode user data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func changeUser(to user: User) {
        DispatchQueue.main.async {
            self.selectedUser = user
            UserDefaults.standard.setValue(user.id, forKey: self.userDefaultsKey) // Simpan ID user di UserDefaults
        }
    }

    func deleteUser() {
        guard let user = selectedUser, let userId = user.id, let url = URL(string: "\(apiURL)/\(userId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to delete user")
                return
            }
            
            DispatchQueue.main.async {
                self.users.removeAll { $0.id == user.id }
                self.selectedUser = nil
                UserDefaults.standard.removeObject(forKey: self.userDefaultsKey) // Hapus data dari UserDefaults
            }
        }.resume()
    }

    private func loadSelectedUser() {
        if let savedUserId = UserDefaults.standard.string(forKey: userDefaultsKey) {
            if let user = users.first(where: { $0.id == savedUserId }) {
                self.selectedUser = user
            }
        } else {
            self.selectedUser = nil
        }
    }
}
