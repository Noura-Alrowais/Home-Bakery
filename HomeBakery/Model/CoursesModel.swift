//
//  CoursesModel.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 25/07/1446 AH.
//
import Foundation


struct Welcome: Codable {
    let records: [CourseRecord]
}


struct CourseRecord: Codable,Identifiable {
    let id: String
    let createdTime: CreatedTime
    let fields: CourseFields
    
}

enum CreatedTime: String, Codable {
    case the20250107T224048000Z = "2025-01-07T22:40:48.000Z"
}


struct CourseFields: Codable {
    let locationLongitude: Double
    let locationName: String
    let locationLatitude: Double
    let title: String
    let level: Level
    let endDate: Double
    let id, chefID, description: String
    let startDate: Double

    enum CodingKeys: String, CodingKey {
        case locationLongitude = "location_longitude"
        case locationName = "location_name"
        case locationLatitude = "location_latitude"
        case title, level
        case endDate = "end_date"
        case id
        case chefID = "chef_id"
        case description
        case startDate = "start_date"
    }
    func imageForCourse(_ title: String) -> String {
      switch title{
      case "Babka dough":
          return "Babka"
      case "Cinnamon rolls":
          return "Cinnamon"
      case "Japanese bread":
          return "Japanese"
      case "Banana bread":
          return "Banana"
      default:
          return "Babka"
      }
  }
    func imageForCourseDetail(_ title: String) -> String {
      switch title{
      case "Babka dough":
          return "BabkaD"
      case "Cinnamon rolls":
          return "CinnamonD"
      case "Japanese bread":
          return "JapaneseD"
      case "Banana bread":
          return "BananaD"
      default:
          return "BabkaD"
      }
  }
}

enum Level: String, Codable {
    case advance = "advance"
    case beginner = "beginner"
    case intermediate = "intermediate"
}

