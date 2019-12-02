//
//  HowItWorksPageController.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class HowItWorksPageController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubviewToFront(subView)
            }
        }
        super.viewDidLayoutSubviews()
    }

}
