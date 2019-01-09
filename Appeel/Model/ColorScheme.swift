//
//  ColorScheme.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/6/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    
    // fonts
    public static let pingFang50 = UIFont(name: "PingFangSC-Ultralight", size: 50.0)
    public static let pingFang24 = UIFont(name: "PingFangSC-Ultralight", size: 24.0)
    public static let pingFang20 = UIFont(name: "PingFangSC-Ultralight", size: 20.0)
    public static let pingFang18 = UIFont(name: "PingFangSC-Ultralight", size: 18.0)
    public static let pingFang18b = UIFont(name: "PingFangSC-Light", size: 18.0)
    public static let pingFang10 = UIFont(name: "PingFangSC-Ultralight", size: 10.0)
    public static let cochinItalic50 = UIFont(name: "Cochin-Italic", size: 50.0)
    public static let cochinItalic60 = UIFont(name: "Cochin-Italic", size: 60.0)
    
    // colors
    public static let pixelColorLim: CGFloat = 256.0
    public static let buttonTransparency: CGFloat = 0.7
    public static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public static let red = UIColor(red: 229.0/pixelColorLim, green: 114.0/pixelColorLim, blue: 94.0/pixelColorLim, alpha: 1)
    public static let green = UIColor(red: 59.0/pixelColorLim, green: 217.0/pixelColorLim, blue: 88.0/pixelColorLim, alpha: buttonTransparency)
    public static let pink = UIColor(red: 226.0/pixelColorLim, green: 164.0/pixelColorLim, blue: 235.0/pixelColorLim, alpha: buttonTransparency)
    public static let yellow = UIColor(red: 200.0/pixelColorLim, green: 219.0/pixelColorLim, blue: 88.0/pixelColorLim, alpha: buttonTransparency)
}
