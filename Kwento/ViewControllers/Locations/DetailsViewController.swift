//
//  DetailsViewController.swift
//  Kwento
//
//  Created by Art John on 21/02/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var imageItem: UIImageView!
    @IBOutlet var titleText: UILabel!
    var titleVal : String = ""
    var imageVal : String = ""
    var descriptionVal : String = ""
    var mainNavigationController: MainNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainNavigationController = navigationController as? MainNavigationController
        initView()
    }
    
    func initView() {
        titleText.text = titleVal
        descriptionText.text = descriptionVal
        imageItem.image = PublicData.getSavedImage(named: "\(imageVal).png")
    }
    
    @IBAction func close(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
    }
}
