//
//  dash.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 29/07/1446 AH.
//

import SwiftUI

struct DashboardView: View {
    
    var user: User
    @ObservedObject var courseViewModel = CourseViewModel()
    @ObservedObject var viewModel = LoginViewModel()
    @ObservedObject var BookingsViewModel = CourseViewModel()
    var body: some View {
        VStack {
            headerView
            Divider()
                .background(Color.gray.opacity(0.5))
            userInfoView
            bookedCoursesView
            
            
        }
        .background(Color("Background"))
        .onAppear {
            
            
            courseViewModel.fetchCourses()
            BookingsViewModel.fetchBookings(userId: user.id)
            
            
            
            
        } .toolbar {
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    // Icon 1: Bake
                    VStack {
                        Button(action: {
                            
                            print("Icon 1 tapped!")
                        }) {
                            Image("main")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 29, height: 24)
                        }
                        Text("Bake")
                            .font(.custom("SFProRounded-Medium", size: 12))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Icon 2: Courses
                    VStack {
                        Button(action: {
                            
                            print("Icon 2 tapped!")
                            
                        }) {
                            Image("courses")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 67, height: 17)
                        }
                        Text("Courses")
                            .font(.custom("SFProRounded-Medium", size: 12))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Icon 3: Profile
                    VStack {
                        Button(action:{
                            if viewModel.isLoggedIn {
                                                               print("Navigating to Profile")
   
                                print("Navigating to Login")
                            }})
                        {
                            Image("ProfileT")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 26)                       }
                        Text("Profile")
                            .font(.custom("SFProRounded-Medium", size: 12))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        
        
    }
    
    // قسم العنوان
    private var headerView: some View {
        Text("Profile")
            .font(.custom("SFProRounded-Semibold", size: 17))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // قسم معلومات المستخدم
    private var userInfoView: some View {
        ZStack {
            Rectangle()
                .frame(width: 359, height: 65)
                .cornerRadius(8)
                .foregroundStyle(Color.white)
                .shadow(radius: 4)
            
            HStack {
                Image("ProfilePic")
                    .resizable()
                    .frame(width: 46.0, height: 46.0)
                    .padding(.leading, 25.0)
                Text(user.name)
                    .font(.custom("SFProRounded-Semibold", size: 17))
                Spacer()
                Text("Edit").padding()
            }
            .padding()
        }
    }
    
    // قسم الدورات المحجوزة
    private var bookedCoursesView: some View {
        VStack(alignment: .leading) {
            Text("Booked Courses")
                .font(.custom("SFProRounded-Semibold", size: 24)).frame(width: 300.0)
            
                .padding(.trailing, 200)
            
            if BookingsViewModel.bookings.isEmpty {
                Image("EmptyState")
                    .resizable()
                    .frame(width: 174.0, height: 43.0)
                    .padding(.leading, 100.0)
                    .padding(.top, 20)
                Text("You don't have any booked courses")
                    .font(.custom("SFProRounded-Medium", size: 14))
                    .foregroundColor(.gray)
                    .padding(.leading, 83.0)
                    .padding(.top, 5.0)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(BookingsViewModel.bookings, id: \.id) { booking in
                            if let course = courseViewModel.courses.first(where: { $0.fields.id == booking.fields.course_id }) {
                                
                                CourseCard(course: course, viewModel: BookingsViewModel)
                            }
                        }
                    }
                    .padding(.leading, 50.0)
                }
            }
            
        }
    }
    
    struct BookedCourseCard: View {
        let course: CourseRecord
        @ObservedObject var viewModel: CourseViewModel 
        
        var body: some View {
            VStack (alignment: .leading) {
                HStack {
                    Image(course.fields.imageForCourse(course.fields.title))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 94.0, height: 85.0)
                    
                    VStack(alignment: .leading, spacing: 6.0) {
                        Text(course.fields.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .font(.custom("SFProRounded-Semibold", size: 16))
                        printLevel(level: course.fields.level)
                        
                        HStack {
                            Image(systemName: "hourglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10.0, height: 13.0)
                                .foregroundColor(Color("Brown"))
                            
                            let duration = viewModel.getDuration(startDate: course.fields.startDate, endDate: course.fields.endDate)
                            
                            Text(duration)
                                .font(.custom("SFProRounded-Medium", size: 12))
                                .foregroundColor(Color.black)
                        }
                        .padding(.trailing, 70)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16.0, height: 13.0)
                                .foregroundColor(Color("Brown"))
                            
                            Text(viewModel.formatDate(from: course.fields.startDate))
                                .font(.custom("SFProRounded-Medium", size: 11))
                                .foregroundColor(Color.black)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.top, 5.0)
                }
                .padding(.trailing, 115)
            }
            .frame(width: 370, height: 110)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 1)
            .padding(.horizontal)
        }
    }
}
    struct DashboardView_Previews: PreviewProvider {
        static var previews: some View {
            DashboardView(user: User(id: "04AE7129-7AF9-4F20-A7D6-1E79B1F32E537", email: "user@example.com", name: "John Doe", password: "password123"))
        }
    }

