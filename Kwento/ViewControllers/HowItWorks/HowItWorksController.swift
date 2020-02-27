//
//  HowItWorksController.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class HowItWorksController: UIViewController {
    
    @IBOutlet var instructionText: UILabel!
    let images = [#imageLiteral(resourceName: "how_1"),#imageLiteral(resourceName: "how_2"),#imageLiteral(resourceName: "how_3"),#imageLiteral(resourceName: "how_4"),#imageLiteral(resourceName: "how_5"),#imageLiteral(resourceName: "how_6"),#imageLiteral(resourceName: "how_7"),#imageLiteral(resourceName: "how_8")]
    let instructions = ["Instruction 1",
                        "Instruction 2",
                        "Instruction 3",
                        "Instruction 4",
                        "Instruction 5",
                        "Instruction 6",
                        "Instruction 7",
                        "Instruction 8"]
    var currentViewControllerIndex = 0
    var shownViewControllerIndex = 0
    var howItWorksPageController: HowItWorksPageController!
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: MDCFlatButton!
    @IBOutlet weak var nextButton: MDCFlatButton!
    @IBOutlet weak var finishButton: MDCFlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        configurePageViewController()
    }
    
    @IBAction func skip(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        SelectedNav.item = .dashboard
    }
    
    @IBAction func back(_ sender: Any) {
        shownViewControllerIndex -= 1
        howItWorksPageController.goToPreviousPage()
    }
    
    @IBAction func next(_ sender: Any) {
        shownViewControllerIndex += 1
        howItWorksPageController.goToNextPage()
    }
    
    @IBAction func finish(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        SelectedNav.item = .dashboard
    }
    
    private func initViews() {
        backButton.initialize(backgroundColor: UIColor(rgb: 0xc5c5c5), titleColor: .white, cornerRadius: 4)
        nextButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        finishButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
    }
    
    private func configurePageViewController() {
        
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: HowItWorksPageController.self)) as? HowItWorksPageController else {
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.backgroundColor = .clear
        
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingViewController = detailViewControllerAt(index: currentViewControllerIndex) else {
            return
        }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        
        howItWorksPageController = pageViewController
    }
    
    func detailViewControllerAt(index: Int) -> PageImageController? {
        
        if index >= images.count || images.count == 0 {
            return nil
        }
        
        guard let pageImageController = storyboard?.instantiateViewController(withIdentifier: String(describing: PageImageController.self)) as? PageImageController else {
            return nil
        }
        
        pageImageController.index = index
        pageImageController.image = images[index]
        instructionText.text =  instructions[index]
        return pageImageController
    }
    
}

extension HowItWorksController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let pageImageController = pendingViewControllers[0] as? PageImageController
        shownViewControllerIndex = pageImageController!.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        _ = pageViewController.dataSource?.presentationIndex?(for: pageViewController)
        if shownViewControllerIndex == 0 {
            nextButton.setVisibility(true)
            backButton.setVisibility(false)
            finishButton.setVisibility(false)
        }
        else if shownViewControllerIndex == images.count - 1 {
            nextButton.setVisibility(false)
            backButton.setVisibility(false)
            finishButton.setVisibility(true)
        }
        else {
            nextButton.setVisibility(true)
            backButton.setVisibility(true)
            finishButton.setVisibility(false)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageImageController = viewController as? PageImageController
        
        guard var currentIndex = pageImageController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageImageController = viewController as? PageImageController
        
        guard var currentIndex = pageImageController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == images.count {
            return nil
        }
        
        currentIndex += 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return shownViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    
}
