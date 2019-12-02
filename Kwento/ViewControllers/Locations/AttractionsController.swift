//
//  AttractionsController.swift
//  Kwento
//
//  Created by Richtone Hangad on 11/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class AttractionsController: UIViewController {

    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var contentView: UIView!
    
    var attractionsPageController: AttractionsPageController!
    
    var tabBar: MDCTabBar!
    
    lazy var tabBarItems: [UITabBarItem] = {
        return [
            UITabBarItem(title: nil, image: #imageLiteral(resourceName: "round_house_black_36pt"), tag: 0),
            UITabBarItem(title: nil, image: #imageLiteral(resourceName: "round_account_balance_black_36pt"), tag: 1)
        ]
    }()
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Attractions", bundle: nil).instantiateViewController(withIdentifier: String(describing: CategoriesController.self)),
            UIStoryboard(name: "Attractions", bundle: nil).instantiateViewController(withIdentifier: String(describing: LocationsController.self)),
        ]
    }()
    
    var mainNavigationController: MainNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        configurePageViewController()
        mainNavigationController = navigationController as? MainNavigationController
    }
    
    @IBAction func didTapNavButton(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func didTapSeach(_ sender: Any) {
        
    }
    
    func initViews() {
        tabBar = MDCTabBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 48, height: containerView.frame.size.height))
        
        tabBar.items = tabBarItems
        tabBar.itemAppearance = .images
        tabBar.delegate = self
        tabBar.selectedItemTintColor = .mainDark
        tabBar.setImageTintColor(.mainDark, for: .selected)
        tabBar.setImageTintColor(.mainDark, for: .normal)
        tabBar.setTitleColor(.black, for: .normal)
        tabBar.tintColor = .mainDark
        tabBar.inkColor = UIColor.lightGray.withAlphaComponent(0.1)
        tabBar.alignment = .justified
        
        tabBar.autoresizingMask = .flexibleHeight
        containerView.addSubview(tabBar)
    }
    
    private func configurePageViewController() {
        
        let storyboard = UIStoryboard(name: "Attractions", bundle: nil)
        
        guard let pageViewController = storyboard.instantiateViewController(withIdentifier: String(describing: AttractionsPageController.self)) as? AttractionsPageController else {
            return
        }
        
        attractionsPageController = pageViewController
        
        attractionsPageController.delegate = self
        attractionsPageController.dataSource = self
        
        addChild(attractionsPageController)
        attractionsPageController.didMove(toParent: self)
        
        attractionsPageController.view.translatesAutoresizingMaskIntoConstraints = false
        attractionsPageController.view.backgroundColor = .clear
        
        contentView.addSubview(attractionsPageController.view)
        
        let views: [String: Any] = ["pageView": attractionsPageController.view!]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        attractionsPageController.setViewControllers([subViewControllers[0]], direction: .forward, animated: true)
        
        containerView.bringSubviewToFront(contentView)
    }

}

extension AttractionsController: MDCTabBarDelegate {
    
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        attractionsPageController.setViewControllers([subViewControllers[item.tag]], direction: item.tag == 0 ? .reverse : .forward, animated: true)
    }
    
}

extension AttractionsController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let controller = pendingViewControllers[0]
        let index = subViewControllers.firstIndex(of: controller)!
        tabBar.setSelectedItem(tabBarItems[index], animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            let controller = previousViewControllers[0]
            let index = subViewControllers.firstIndex(of: controller)!
            tabBar.setSelectedItem(tabBarItems[index], animated: true)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        subViewControllers.count
    }

}
