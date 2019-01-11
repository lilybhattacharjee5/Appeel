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
    
    public static func getClarifaiApp() -> ClarifaiApp {
        return clarifaiApp
    }
}
