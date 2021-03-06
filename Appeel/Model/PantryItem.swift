//
//  PantryItem.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Foundation

// items input by the user into their virtual pantry
class PantryItem {
    
    // label and brand come from selected food item in search controller
    private var image: UIImage!
    private var label: String!
    private var brand: String!
    private var imgUrl: String!
    
    init(image: UIImage, label: String, brand: String, imgUrl: String) {
        self.image = image
        self.label = label
        self.brand = brand
        self.imgUrl = imgUrl
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
    
    public func getImgUrl() -> String {
        return self.imgUrl
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
    
    public func setImgUrl(imgUrl: String) {
        self.imgUrl = imgUrl
    }
    
}
