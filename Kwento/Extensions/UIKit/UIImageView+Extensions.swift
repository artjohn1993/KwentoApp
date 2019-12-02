//
//  UIImageView+Extensions.swift
//  Kwento
//
//  Created by Richtone Hangad on 22/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImageRenderingMode(_ renderMode: UIImage.RenderingMode) {
        assert(image != nil, "Image must be set before setting rendering mode")
        // AlwaysOriginal as an example
        image = image?.withRenderingMode(.alwaysOriginal)
    }
}
