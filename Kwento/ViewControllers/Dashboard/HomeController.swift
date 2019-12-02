//
//  HomeController.swift
//  Kwento
//
//  Created by Richtone Hangad on 10/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import Pulsator

class HomeController: UIViewController {
    
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var outerCircle: UIView!
    
    let pulsator = Pulsator()
    var mainNavigationController: MainNavigationController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = outerCircle.layer.position
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pulsator.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        pulsator.stop()
    }
    
    @IBAction func didTapNavButton(_ sender: UITapGestureRecognizer) {
        mainNavigationController.setDrawerState()
    }
    
    private func initViews() {
        navButton.image = #imageLiteral(resourceName: "nav_button").withRenderingMode(.alwaysTemplate)
        navButton.tintColor = .white
        
        outerCircle.layer.cornerRadius = outerCircle.frame.size.width / 2
        
        outerCircle.layer.superlayer?.insertSublayer(pulsator, below: outerCircle.layer)
        pulsator.numPulse = 3
        pulsator.radius = 84
        pulsator.animationDuration = 5
        pulsator.position = outerCircle.layer.position
        pulsator.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pulsator.keyTimeForHalfOpacity = 0.8
    
    }

}
