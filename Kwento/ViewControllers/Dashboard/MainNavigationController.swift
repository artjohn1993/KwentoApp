//
//  MainNavigationController.swift
//  Kwento
//
//  Created by Richtone Hangad on 13/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import KYDrawerController

class MainNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainNavigationController")
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let homeController = storyboard.instantiateViewController(withIdentifier: "homeController") as! HomeController
        setViewControllers([homeController], animated: true)
        
        if let drawerController = parent as? KYDrawerController {
            drawerController.screenEdgePanGestureEnabled = true
        }
    }
    
    func setDrawerState() {
        if let drawerController = parent as? DashboardController {
            drawerController.setDrawerState(drawerController.drawerState == .closed ? .opened : .closed, animated: true)
        }
    }

}
