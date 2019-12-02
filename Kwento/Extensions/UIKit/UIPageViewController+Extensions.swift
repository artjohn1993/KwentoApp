//
//  UIPageViewController+Extensions.swift
//  Kwento
//
//  Created by Richtone Hangad on 25/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit

extension UIPageViewController {

    func goToNextPage() {

        guard let currentViewController = self.viewControllers?.first else { return }

        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }

        setViewControllers([nextViewController], direction: .forward, animated: true) { completed in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: completed)
//            _ = self.dataSource?.presentationIndex?(for: self)
        }
    }


    func goToPreviousPage() {

        guard let currentViewController = self.viewControllers?.first else { return }

        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }

        setViewControllers([previousViewController], direction: .reverse, animated: true) { completed in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: completed)
//            _ = self.dataSource?.presentationIndex?(for: self)
        }
    }

}
