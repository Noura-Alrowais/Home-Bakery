import SwiftUI

struct CourseListView: View {
    @StateObject var viewModel = CourseViewModel() // إنشاء ViewModel
    @State private var searchText = ""
    @State private var navigateToLogin = false
     @State private var navigateToProfile = false
     @State private var user: User?

    var filteredCourses: [CourseRecord] {
        if searchText.isEmpty {
            return viewModel.courses
        } else {
            return viewModel.courses.filter { $0.fields.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...") // عرض مؤشر التحميل
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("Courses")
                        .font(.custom("SFProRounded-Semibold", size: 17))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Divider()
                        .background(Color.gray.opacity(0.5))        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.gray))
                            .padding(.leading, 15)

                        ZStack(alignment: .leading) {
                            if searchText.isEmpty {
                                Text("Search")
                                    .foregroundColor(Color(.gray))
                            }
                            TextField("", text: $searchText)
                                .frame(height: 36)
                        }
                    }
                    .frame(width: 370)
                    .background(Color("SearchGray"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    ScrollView {
                        VStack {
                            ForEach(filteredCourses, id: \.id) { course in
                                NavigationLink(destination: CourseDetailView(course: course, viewModel: viewModel)) {
                                    CourseCard(course: course, viewModel: viewModel)
                                        .padding(.horizontal)
                                        .padding(.top, 5)
                                }
                            }
                        }
                    }
                    .background(Color("Background"))

                }
            }
            .background(Color("Background"))
            .navigationBarTitleDisplayMode(.inline)            .onAppear {
                viewModel.chefViewModel.fetchChefs()
                viewModel.fetchCourses()
            }
            
            .toolbar {
                   ToolbarItem(placement: .bottomBar) {
                       HStack {
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

                           VStack {
                               Button(action: {
                                   print("Icon 2 tapped!")
                               }) {
                                   Image("coursesT")
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
                               Button(action: {
                                   if let user = user {
                                       // إذا كان المستخدم مسجل
                                       self.navigateToProfile = true
                                   } else {
                                       // إذا لم يكن مسجل دخول
                                       self.navigateToLogin = true
                                   }
                               }) {
                                   Image("profile")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 28, height: 26)
                               }
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
               .background(NavigationLink("", destination: LoginView(viewModel: LoginViewModel()), isActive: $navigateToLogin))
               .background(NavigationLink("", destination: DashboardView(user: user ?? User(id: "temp", email: "", name: "Guest", password: "")), isActive: $navigateToProfile))
           } .navigationBarBackButtonHidden(true)
       }
   }

struct CourseCard: View {
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

struct CourseListView_Previews: PreviewProvider {
    static var previews: some View {
        CourseListView()
    }
}
