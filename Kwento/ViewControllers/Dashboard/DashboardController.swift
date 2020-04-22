//
//  DashboardController.swift
//  Kwento
//
//  Created by Richtone Hangad on 13/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import KYDrawerController

class DashboardController: KYDrawerController {
//    let service = AttractionServices()
//    let dataService = CoreDataServices()
    override var childForStatusBarStyle: UIViewController? {
        return mainViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        drawerWidth = 281
    
    }

}
