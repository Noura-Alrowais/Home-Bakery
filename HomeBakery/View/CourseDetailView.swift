import SwiftUI
import Foundation
import MapKit

struct CourseDetailView: View {
    let course: CourseRecord
    @ObservedObject var viewModel: CourseViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // لاستخدام dismiss
    @State private var region: MKCoordinateRegion

    init(course: CourseRecord, viewModel: CourseViewModel) {
        self.course = course
        self.viewModel = viewModel
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: course.fields.locationLatitude,
                longitude: course.fields.locationLongitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(course.fields.imageForCourseDetail(course.fields.title))
                .resizable()
                .scaledToFit()
                .frame(width: 430, height: 275)

            Text("About the course:")
                .font(.custom("SFProRounded-Semibold", size: 16))
                .frame(width: 150)
                .padding(.trailing, 250.0)
                .padding(.top, 10)
                .padding(.bottom, -20)

            Text(course.fields.description ?? "No description available")
                .font(.custom("SFProRounded-Regular", size: 14))
                .multilineTextAlignment(.leading)
                .frame(width: 390, height: 51)

            Divider()
                .frame(width: 380)
                .background(Color.gray.opacity(0.5))

            HStack {
                Text("Chef:")
                    .frame(width: 34)
                    .font(.custom("SFProRounded-Semibold", size: 14))
                Text(viewModel.getChefName(for: course))
                    .frame(width: 100)
                    .font(.custom("SFProRounded-Regular", size: 14))
            }.padding(.trailing, 220.0)

            VStack {
                HStack {
                    HStack {
                        Text("Level")
                            .font(.custom("SFProRounded-Semibold", size: 14))
                            .overlay(printLevel(level: course.fields.level).padding(.leading, 190.0))
                    }
                    Spacer()
                    HStack {
                        Text("Duration:")
                            .font(.custom("SFProRounded-Semibold", size: 14))
                        Text(viewModel.getDuration(startDate: course.fields.startDate, endDate: course.fields.endDate))
                            .font(.custom("SFProRounded-Regular", size: 14))
                    }.padding(.trailing, 30.0)
                }

                HStack {
                    Text("Date & Time:")
                        .font(.custom("SFProRounded-Semibold", size: 14))
                    Text(viewModel.formatDate(from: course.fields.startDate))
                        .font(.custom("SFProRounded-Regular", size: 14))
                    Spacer()
                    Text("Location:")
                        .font(.custom("SFProRounded-Semibold", size: 14))
                    Text(course.fields.locationName)
                        .font(.custom("SFProRounded-Regular", size: 14))
                }.padding(.top, 5)
            }

            Map(coordinateRegion: $region, annotationItems: [course]) { course in
                MapPin(coordinate: CLLocationCoordinate2D(
                    latitude: course.fields.locationLatitude,
                    longitude: course.fields.locationLongitude),
                       tint: .blue)
            }
            .frame(width:390,height: 129)
            Button(action: {
                
                print("Button pressed!")
            }) {
                Text("Book a space")
                    .font(.custom("SFProRounded-Semibold", size: 17))
                    .frame(width: 390,height: 48)
                   
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            Spacer()
                
        }
        .background(Color("Background"))
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(course.fields.title, displayMode: .inline)
       
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("Primary"))
                        .font(.system(size: 24))
                }
            }
        }
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCourse = CourseRecord(
            id: "1",
            createdTime: .the20250107T224048000Z,
            fields: CourseFields(
                locationLongitude: 40.7128,
                locationName: "New York",
                locationLatitude: 74.0060,
                title: "SwiftUI Basics",
                level: .beginner,
                endDate: Date().addingTimeInterval(60 * 60 * 24 * 7).timeIntervalSince1970,
                id: "1",
                chefID: "chef_01",
                description: "Learn the basics of SwiftUI in this course.",
                startDate: Date().timeIntervalSince1970
            )
        )

        CourseDetailView(course: mockCourse, viewModel: CourseViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
