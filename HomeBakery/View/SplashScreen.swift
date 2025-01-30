//
//  SplashScreen.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 22/07/1446 AH.
//

import Foundation
import SwiftUI

struct SplashScreen: View {
    @State private var navigateToCourses = false
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle().fill(Color("Background")).ignoresSafeArea() // الخلفية
                VStack {
                    Image("Logo").resizable().scaledToFit().frame(width: 202.61, height: 168.46)
                        .padding()
                    Text("Home Bakery").fontWeight(.bold)
                        .foregroundColor(Color("Brown")).frame(width: 220.0, height: 43.0).font(.custom("SFProRounded-Bold", size: 36))
                    Text("Baked to Perfection").fontWeight(.medium)
                        .foregroundColor(Color("Brown")).frame(width: 218.0, height: 31.0).font(.custom("SFProRounded-Medium", size: 26)).padding(.top, -11.0)
                }
                .padding(.bottom, 100)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.navigateToCourses = true
                    }
                }

                NavigationLink(destination: CourseListView(), isActive: $navigateToCourses) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
