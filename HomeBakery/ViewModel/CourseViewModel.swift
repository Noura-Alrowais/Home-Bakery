//
//  CourseCared.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 25/07/1446 AH.
//
import Foundation
import SwiftUI


extension View {
   func printLevel(level: Level) -> some View {
        if level.rawValue == "advance" {
            return ZStack {
                Rectangle()
                    .cornerRadius(37)
                    .frame(width: 67, height: 14)
                    .foregroundColor(Color("Primary"))
                Text("Advance")
                    .font(.custom("SFProRounded-Medium", size: 10))
                    .foregroundColor(Color("White"))
            }
            .padding(.trailing, 50)
        } else if level.rawValue == "beginner" {
            return ZStack {
                Rectangle()
                    .cornerRadius(37)
                    .frame(width: 67, height: 16)
                    .foregroundColor(Color("Brown"))
                Text("Beginner")
                    .font(.custom("SFProRounded-Medium", size: 10))
                    .foregroundColor(Color("White"))
            }
            .padding(.trailing, 50)
        } else {
            return ZStack {
                Rectangle()
                    .cornerRadius(37)
                    .frame(width: 67, height: 16)
                    .foregroundColor(Color("Cream"))
                Text("Intermediate")
                    .font(.custom("SFProRounded-Medium", size: 10))
                    .foregroundColor(Color("Brown"))
            }
            .padding(.trailing, 50)
        }
    }
}

class CourseViewModel: ObservableObject {
    @Published var courses: [CourseRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var bookings: [Booking] = []  
    @ObservedObject var chefViewModel = ChefViewModel()
    private let apiUrl = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course"
   
    func fetchCourses() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedCourses = try await getCourses()
                DispatchQueue.main.async {
                    self.courses = fetchedCourses
                    self.isLoading = false  }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "\(error)"
                    self.isLoading = false
                }
            }
        }
    }
    func fetchBookings(userId: String) {
     
        print("Fetching bookings for user ID: \(userId)")
         guard !isLoading else { return }
         
         isLoading = true
         errorMessage = nil
         
         Task {
             do {
                 let fetchedBookings = try await getBookings(userId: userId)
                 DispatchQueue.main.async {
                     self.bookings = fetchedBookings
                     self.isLoading = false
                 }
             } catch {
                 DispatchQueue.main.async {
                     self.errorMessage = "\(error)"
                     self.isLoading = false
                 }
             }
         }
     }
    private func getBookings(userId: String) async throws -> [Booking] {
       
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking?filterByFormula=user_id=\"\(userId)\"") else {
            throw CourseError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw CourseError.invalidResponse
            }
            
            print("Status Code: \(httpResponse.statusCode)")  // تحقق من حالة الاستجابة
            
            if httpResponse.statusCode != 200 {
                print("Error Response: \(String(data: data, encoding: .utf8) ?? "No readable data")")  // طباعة محتوى الاستجابة إذا كانت هناك مشكلة
                throw CourseError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            
       
            
            let responseObject = try decoder.decode([String: [Booking]].self, from: data)
            
            if let bookingsData = responseObject["records"] {
                print("Bookings: \(bookingsData)") 
                return bookingsData
            } else {
                throw CourseError.invalidData
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")  // طباعة أي خطأ يحدث
            throw error
        }
    }




    
    private func getCourses() async throws -> [CourseRecord] {
        guard let url = URL(string: apiUrl) else {
            throw CourseError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CourseError.invalidResponse
        }
        
        // سجل الحالة لنتأكد من الكود الفعلي
        print("Status Code: \(httpResponse.statusCode)")  // أضف هذا السطر للطباعة
        
        if httpResponse.statusCode != 200 {
            // طباعة تفاصيل الاستجابة في حالة حدوث خطأ
            print("Response Body: \(String(data: data, encoding: .utf8) ?? "No readable data")")
            throw CourseError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let welcome = try decoder.decode(Welcome.self, from: data)
            return welcome.records
        } catch {
            throw CourseError.invalidData
        }
    }
    func getDuration(startDate: Double, endDate: Double) -> String {
        let startDate = Date(timeIntervalSince1970: startDate)
        let endDate = Date(timeIntervalSince1970: endDate)
        
        let durationInSeconds = endDate.timeIntervalSince(startDate)
        
        // تحويل الثواني إلى ساعات ودقائق
        let hours = Int(durationInSeconds) / 3600
        
        
        // عرض المدة على شكل "X ساعات Y دقائق"
        return "\(hours)h"
    }
    
    
    
    
    
    // دالة لتحويل Unix Timestamp إلى تاريخ مقروء بتنسيق "dd MMM"
    func formatDate(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp) // تحويل timestamp إلى Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM - HH:mm" // تنسيق التاريخ: يوم شهر (مثال: 02 Feb)
        formatter.locale = Locale(identifier: "en_US") // التأكد من أن الشهر يكون باللغة الإنجليزية
        return formatter.string(from: date)
    }
    
    
    
    
    
    
    // دالة للحصول على اسم الشيف بناءً على chefID
    func getChefName(for course: CourseRecord) -> String {
        return chefViewModel.getChefName(by: course.fields.chefID)
    }
    enum CourseError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    
}
