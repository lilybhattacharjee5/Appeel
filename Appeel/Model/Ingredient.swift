//
//  Ingredient.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/7/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class Ingredient: CustomStringConvertible {
    
    private var food: String!
    private var weight: Float! // weight in g
    
    public init(food: String, weight: Float) {
        self.food = food
        self.weight = weight
    }
    
    public var description: String {
        return self.food
    }
    
}
