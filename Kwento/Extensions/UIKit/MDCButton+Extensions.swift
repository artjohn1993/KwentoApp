//
//  MDCButton+Extensions.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialButtons

extension MDCButton {
    
    func initialize(backgroundColor: UIColor, titleColor: UIColor, cornerRadius: CGFloat) {
        setBackgroundColor(backgroundColor, for: .normal)
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = cornerRadius
    }
    
}
