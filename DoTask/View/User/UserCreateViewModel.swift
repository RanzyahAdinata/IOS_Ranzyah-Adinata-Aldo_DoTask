//
//  UserCreateViewModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 26/02/25.
//

import Foundation

class UserCreateViewModel: ObservableObject {
    private let apiURL = "https://67bd5803321b883e790c13f4.mockapi.io/dotask-api/users/users"
    
    func createUser(name: String, email: String, completion: @escaping () -> Void) {
        guard let url = URL(string: apiURL) else { return }
        
        let newUser = ["name": name, "email": email]
        let jsonData = try? JSONSerialization.data(withJSONObject: newUser)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Failed to create user")
                return
            }
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}
