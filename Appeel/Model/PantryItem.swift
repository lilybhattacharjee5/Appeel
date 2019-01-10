//
//  PantryItem.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Foundation

class PantryItem {
    
    private var image: UIImage!
    private var label: String!
    private var brand: String!
    
    init(image: UIImage, label: String, brand: String) {
        self.image = image
        self.label = label
        self.brand = brand
    }
    
    // getter methods
    public func getImage() -> UIImage {
        return self.image
    }
    
    public func getLabel() -> String {
        return self.label
    }
    
    public func getBrand() -> String {
        return self.brand
    }
    
    // setter methods
    public func setImage(image: UIImage) {
        self.image = image
    }
    
    public func setLabel(label: String) {
        self.label = label
    }
    
    public func setBrand(brand: String) {
        self.brand = brand
    }
    
}
