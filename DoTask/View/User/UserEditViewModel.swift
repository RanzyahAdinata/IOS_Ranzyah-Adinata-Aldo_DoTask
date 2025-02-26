//
//  UserEditViewModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 26/02/25.
//

import Foundation

class UserEditViewModel: ObservableObject {
    private let apiURL = "https://67bd5803321b883e790c13f4.mockapi.io/dotask-api/users/users"
    @Published var selectedUser: User?
    
    func loadUserData(completion: @escaping (String, String) -> Void) {
        if let user = selectedUser {
            completion(user.name, user.email)
        }
    }
    
    func updateUser(name: String, email: String, completion: @escaping () -> Void) {
        guard let user = selectedUser, let url = URL(string: "\(apiURL)/\(user.id)") else { return }
        
        let updatedUser = ["name": name, "email": email]
        let jsonData = try? JSONSerialization.data(withJSONObject: updatedUser)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Failed to update user")
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}

