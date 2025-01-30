//
//  UserViewModel.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 29/07/1446 AH.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var courses: [CourseRecord] = []
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var courseViewModel: CourseViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User, courseViewModel: CourseViewModel) {
        self.user = user
        self.courseViewModel = courseViewModel
    }
    
    func fetchUser() {
        self.isLoading = true
        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/users/\(self.user.id)")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { user in
                self.user = user
            })
            .store(in: &cancellables)
    }
    
    func fetchCourses() {
        self.courses = courseViewModel.courses
    }
    
    func fetchBookings() {
        self.isLoading = true
        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Booking].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { bookings in
                self.bookings = bookings
            })
            .store(in: &cancellables)
    }
    
    
    func getUserCourses() -> [CourseRecord] {
        let userBookings = bookings.filter { $0.fields.user_id == user.id }
        let userCourseIds = userBookings.map { $0.fields.course_id}
        return courses.filter { userCourseIds.contains($0.id) }
    }
    
    
    func updateUserName(newName: String) {
        self.user.name = newName
    }
}
