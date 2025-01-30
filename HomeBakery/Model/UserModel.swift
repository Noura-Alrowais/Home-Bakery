//
//  UserModel.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 29/07/1446 AH.
//

import Foundation


struct User: Codable, Identifiable {
    var id: String
    var email: String
    var name: String
    var password: String
}

struct Users: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable {
    let id: String
    let fields: UserFields
}

struct UserFields: Codable {
    let id:String
    let name: String
    let email: String
    let password: String }

