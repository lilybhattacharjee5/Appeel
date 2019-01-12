//
//  apiKeys.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation
import Clarifai

class ApiKeys {
    private static let clarifaiApp: ClarifaiApp = ClarifaiApp(apiKey: "f60e7d567bea4ad192f645f839c8976b")
    private static let edamamFoodAppId: String = "a45d2060"
    private static let edamamFoodAppKey: String = "273ebdd46ede074bc43ae62ebee89d0f"
    private static let edamamRecipeAppId: String = "a4c5cb52"
    private static let edamamRecipeAppKey: String = "2df4ac35c025f1afe9ae4123fea86d63"
    
    public static func getClarifaiApp() -> ClarifaiApp {
        return clarifaiApp
    }
    
    public static func getEdamamFoodAppId() -> String {
        return edamamFoodAppId
    }
    
    public static func getEdamamFoodAppKey() -> String {
        return edamamFoodAppKey
    }
    
    public static func getEdamamRecipeAppId() -> String {
        return edamamRecipeAppId
    }
    
    public static func getEdamamRecipeAppKey() -> String {
        return edamamRecipeAppKey
    }
}
