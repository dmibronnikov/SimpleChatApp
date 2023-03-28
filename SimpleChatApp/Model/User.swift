//
//  User.swift
//  SimpleChat
//
//  Created by Dmitriy Bronnikov on 27.03.2023.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let surname: String
    
    var username: String { "\(name) \(surname)" }
}
