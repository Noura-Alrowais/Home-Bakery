//
//  ChefsModel.swift
//  HomeBakery
//
//  Created by Noura Alrowais on 21/07/1446 AH.
//

import Foundation

struct Chefs: Codable {
    let records: [ChefRecord]
}


struct ChefRecord: Codable {
    let id: String
    let createdTime: String
    let fields: ChefFields
}


struct ChefFields: Codable {
    let name: String
    let password: String
    let id: String
    let email: String
}


