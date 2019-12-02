//
//  PageImageController.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class PageImageController: UIViewController {

    var image: UIImage!
    var index: Int!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
