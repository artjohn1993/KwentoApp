//
//  UIColor+Extensions.swift
//  Kwento
//
//  Created by Richtone Hangad on 22/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public static var main: UIColor {
        return UIColor(rgb: 0x10CFC9)
    }
    
    public static var mainLight: UIColor {
        return UIColor(rgb: 0x11CFC8)
    }
    
    public static var mainDark: UIColor {
        return UIColor(rgb: 0x0C9C97)
    }
    
    public static var facebook: UIColor {
        return UIColor(rgb: 0x3B5998)
    }
    
    public static var google: UIColor {
        return UIColor(rgb: 0x4285F4)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}
