//
//  ChefViewModel.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 28/07/1446 AH.
//
import Foundation
import SwiftUI
class ChefViewModel: ObservableObject {
    @Published var chefs: [ChefRecord] = []
    @State private var errorMessage: String? = nil
    private let apiUrl = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/chef"

    func fetchChefs() {
        errorMessage = nil
        
        Task {
            do {
                let fetchedChefs = try await getChefs()
                DispatchQueue.main.async {
                    self.chefs = fetchedChefs
                    print("Chefs fetched: \(self.chefs)")
                    
                    if self.chefs.isEmpty {
                        print("No chefs found")
                    } else {
                        print("Found \(self.chefs.count) chefs")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "\(error)"
                    print("Error fetching chefs: \(error)")
                }
            }
        }
    }



    private func getChefs() async throws -> [ChefRecord] {
        guard let url = URL(string: apiUrl) else {
            throw ChefError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ChefError.invalidResponse
        }
        
        print("HTTP Status Code: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode != 200 {
            print("Response Body: \(String(data: data, encoding: .utf8) ?? "No readable data")")
            throw ChefError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let chefsResponse = try decoder.decode(Chefs.self, from: data)
        print("Chefs Response: \(chefsResponse)")
        return chefsResponse.records
    }


    func getChefName(by chefID: String) -> String {
        print("Looking for chef with ID: \(chefID)")
        
        if let chef = chefs.first(where: { $0.fields.id == chefID }) {
            print("Found chef: \(chef.fields.name)")
            return chef.fields.name
        } else if chefID.isEmpty {
            print("Chef ID is empty")
            return "Empty"
        } else {
            print("Chef not found for ID: \(chefID)")
            return "Unknown"  
        }
    }

    enum ChefError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
}



//import Foundation
//import SwiftUI
//class ChefViewModel:ObservableObject {
//    @Published var chefs:[String]=[]
//    @State private var errorMessage: String? = nil // رسالة الخطأ (إن وجدت)
//    private let apiUrl = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/chef"
//    
//    
//     func fetchChefs() {
//      
//        errorMessage = nil
//        
//        Task {
//            do {
//                // استدعاء دالة الجلب من الـ API
//                let fetchedChefs = try await getChefs()
//                DispatchQueue.main.async {
//                    self.chefs = fetchedChefs
//                  
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    print("Error: \(error)") // طباعة تفاصيل الخطأ
//                    self.errorMessage = "\(error)"
//                   
//                }
//            }
//        }
//    }
//
//   func getChefs() async throws -> [String] {
//      
//        guard let url = URL(string: apiUrl) else {
//            throw ChefError.invalidURL
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization") // ضع مفتاح الـ API هنا
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            print("Invalid response type")
//            throw ChefError.invalidResponse
//        }
//        
//        print("Status code: \(httpResponse.statusCode)")
//        
//        guard httpResponse.statusCode == 200 else {
//            print("Response body: \(String(data: data, encoding: .utf8) ?? "No readable data")")
//            throw ChefError.invalidResponse
//        }
//
//        do {
//            let decoder = JSONDecoder()
//            let chefsResponse = try decoder.decode(Chefs.self, from: data)
//            return chefsResponse.records.map { $0.fields.name }
//        } catch {
//            print("Decoding error: \(error)")
//            throw ChefError.invalidData
//        }
//    }
//
//
//
//    enum ChefError: Error {
//        case invalidURL
//        case invalidResponse
//        case invalidData
//    }
//}
