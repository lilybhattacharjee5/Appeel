//
//  UserProfile.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class UserProfile {
    
    // user properties
    let email: String!
    var firstName: String!
    var lastName: String!
    var imgCounter: Int!
    
    // initializes new user profile
    init(email: String, firstName: String, lastName: String, imgCounter: Int) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.imgCounter = imgCounter
    }
    
    // returns all user profile properties as a dictionary
    func toDict() -> [String: String] {
        return [
            "email": self.email,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "imgCounter": String(self.imgCounter)
        ]
    }
}
