//
//  NutrientInfo.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/7/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class NutrientInfo: CustomStringConvertible {
    
    private var label: String
    
    public init(label: String) {
        self.label = label
    }
    
    public var description: String {
        return self.label
    }
    
}
