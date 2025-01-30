//
//  lg.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 29/07/1446 AH.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var user: User?
    @Published var isLoggedIn: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user"
    private let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"
    
    // دالة تسجيل الدخول
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var request = URLRequest(url: URL(string: apiURL)!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let queryItems = [
            URLQueryItem(name: "filterByFormula", value: "{email}='\(email)'")
        ]
        var urlComponents = URLComponents(string: apiURL)!
        urlComponents.queryItems = queryItems
        request.url = urlComponents.url
        
        // إرسال الطلب إلى الـ API
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Users.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Error: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { response in
                if let userRecord = response.records.first {
                    if self.password == userRecord.fields.password {
                        self.user = User(id: userRecord.id, email: self.email, name: userRecord.fields.name, password: self.password)
                        self.isLoggedIn = true
                    } else {
                        self.errorMessage = "Invalid password."
                    }
                } else {
                    self.errorMessage = "No user found with this email."
                }
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
