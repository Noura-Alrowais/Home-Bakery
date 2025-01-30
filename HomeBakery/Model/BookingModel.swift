//
//  BookingModel.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 29/07/1446 AH.
//

struct Booking: Codable {
    let id: String
    let fields: BookingFields
}

struct BookingFields: Codable {
    let course_id: String
    let user_id: String
    let status: String
}

struct BookingResponse: Codable {
    let records: [Booking]
}
