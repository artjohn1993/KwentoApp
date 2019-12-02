//
//  DrawerController.swift
//  Kwento
//
//  Created by Richtone Hangad on 13/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class DrawerController: UIViewController {
    
    var dashboardController: DashboardController!
    var mainNavigationController: MainNavigationController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardController = parent as? DashboardController
        mainNavigationController = dashboardController.mainViewController as? MainNavigationController
    }
    
    func closeCurrentModule() {
        
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()!
            self?.mainNavigationController.pushViewController(viewController, animated: true)
            
        }
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func didTapInfo(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "HowItWorks", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()!
            self?.mainNavigationController.pushViewController(viewController, animated: true)
        }
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func didTapLocations(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Attractions", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()!
            self?.mainNavigationController.pushViewController(viewController, animated: true)
            
        }
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func didTapVisits(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Visits", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()!
            self?.mainNavigationController.pushViewController(viewController, animated: true)
            
        }
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func didTapSupport(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Support", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController()!
            self?.mainNavigationController.pushViewController(viewController, animated: true)
            
        }
        mainNavigationController.setDrawerState()
    }
}
