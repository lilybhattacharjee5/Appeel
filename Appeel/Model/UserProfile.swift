//
//  UserProfile.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class UserProfile {
    
    let email: String!
    var firstName: String!
    var lastName: String!
    
    init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func toDict() -> [String: String] {
        return [
            "email": self.email,
            "firstName": self.firstName,
            "lastName": self.lastName
        ]
    }
}
