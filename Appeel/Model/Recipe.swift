//
//  Recipe.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class Recipe {
    
    // recipe properties
    private let label: String!
    private let imgUrl: String!
    private let source: String!
    private let yield: Float!
    private let calories: Float!
    private let totalTime: Float!
    private let totalWeight: Float!
    private let ingredients: [Ingredient]!
    private let totalNutrients: [NutrientInfo]!
    private let totalDaily: [NutrientInfo]!
    private let dietLabels: [String]!
    private let healthLabels: [String]!
    private let url: String!
    private let recipeId: String!
    
    public init(label: String,
         imgUrl: String,
         source: String,
         yield: Float,
         calories: Float,
         totalTime: Float,
         totalWeight: Float,
         ingredients: [Ingredient],
         totalNutrients: [NutrientInfo],
         totalDaily: [NutrientInfo],
         dietLabels: [String],
         healthLabels: [String],
         url: String
        ) {
        self.label = label
        self.imgUrl = imgUrl
        self.source = source
        self.yield = yield
        self.calories = calories
        self.totalTime = totalTime
        self.totalWeight = totalWeight
        self.ingredients = ingredients
        self.totalNutrients = totalNutrients
        self.totalDaily = totalDaily
        self.dietLabels = dietLabels
        self.healthLabels = healthLabels
        self.url = url
        self.recipeId = UUID().uuidString
    }
    
    public func allAttributes() -> [[String]] {
        let returnedAttributes: [[String]] = [
            ["Source", self.source],
            ["Servings", String(self.yield)],
            ["Calories", String(self.calories)],
            ["Total Time (min)", String(self.totalTime)],
            ["Total Weight (g)", String(self.totalWeight)],
            ["Ingredients", changeListOfObject(lst: self.ingredients).joined(separator: ",\n")],
            ["Diet Labels", self.dietLabels.joined(separator: ",\n")],
            ["Health Labels", self.healthLabels.joined(separator: ",\n")],
            ["Url", self.url]
        ]
        return returnedAttributes
    }
    
    public func allAttributesDict() -> [String: String] {
        let returnedAttributes: [String: String] = [
            "label": self.label,
            "imgUrl": self.imgUrl,
            "Source": self.source,
            "Servings": String(self.yield),
            "Calories": String(self.calories),
            "Total Time (min)": String(self.totalTime),
            "Total Weight (g)": String(self.totalWeight),
            "Ingredients": changeListOfObject(lst: self.ingredients).joined(separator: ",\n"),
            "Diet Labels": self.dietLabels.joined(separator: ",\n"),
            "Health Labels": self.healthLabels.joined(separator: ",\n"),
            "Url": self.url
        ]
        return returnedAttributes
    }
    
    private func changeListOfObject(lst: [CustomStringConvertible]) -> [String] {
        var returnedLst: [String] = []
        for elem in lst {
            returnedLst.append(String(describing: elem))
        }
        return returnedLst
    }
    
    // getter methods
    public func getLabel() -> String {
        return self.label
    }
    
    public func getImgUrl() -> String {
        return self.imgUrl
    }
    
    public func getTotalTime() -> Float {
        return self.totalTime
    }
    
    public func getCalories() -> Float {
        return self.calories
    }
    
    public func getUrl() -> String {
        return self.url
    }
    
    public func getId() -> String {
        return self.recipeId
    }

}
