//
//  ViewController.swift
//  Kwento
//
//  Created by Richtone Hangad on 05/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func initViews() {
        
    }

}

