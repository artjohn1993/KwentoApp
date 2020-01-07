//
//  RatingController.swift
//  Kwento
//
//  Created by Art John on 16/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import CoreData
import Alamofire

class RatingController: UIViewController  {
    let visitService = VisitServices()
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet var message: UITextView!
    @IBOutlet weak var imageLocation: UIImageView!
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var closeButton: UIImageView!
    var mainNavigationController: MainNavigationController!
    let sessionService = SessionServices()
    var visit = [[String:Any]]()
    var attractionService = AttractionServices()
    var index = 0
    var rate = 0
    
    override func viewDidLoad() {
    super.viewDidLoad()
        mainNavigationController = navigationController as? MainNavigationController
        viewInit()
        print("index:\(index)")
        rating.rating = Double(rate)
        sessionService.getUserSession(completion: { result in
            print("after call")
            if result != nil {
                self.visit = result?["rows"] as? [[String:Any]] ?? []
                self.visit.reverse()
                self.setView()
                
            }

        })
        
        rating.didFinishTouchingCosmos = { rate in
            print(rate)
            self.rate = Int(rate)
        }
        
        message.layer.borderWidth = 1
        message.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func didTapNavButton() {
        mainNavigationController.setDrawerState()
    }
    
    @objc func closeProfile() {
        mainNavigationController.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        let id = visit[index]["attraction_id"] as? Int
        let userId = visit[index]["user_id"] as? Int
        let attraction = visit[index]["attraction"] as? [String:Any]
        
        let parameters: Parameters = [
            "attraction_id" : id,
            "user_id" : userId,
            "rating" : rate,
            "review_text": message.text,
            "attraction" : attraction
        ]
        
        visitService.rate(parameter: parameters, completion: { result in
            self.mainNavigationController.popViewController(animated: true)
        })
       
    }
    
    func setView() {
        let attraction = visit[index]["attraction"] as? [String:Any]
        
        let image = attraction?["image_filename"] as? String
        print(image!)
        var imageChecker = PublicData.getSavedImage(named: "\(image!).png")
        print(imageChecker)
        if imageChecker == nil {
            if image != nil {
                attractionService.downloadImage(idImage: image!, completion: { result in
                    print("set Image")
                    print(image!)
                    self.imageLocation.image = PublicData.getSavedImage(named: "\(image!).png")
                })
            }
        }
        else {
            print("wala na ni download")
            self.imageLocation.image = PublicData.getSavedImage(named: "\(image!).png")
        }

        locationName.text = attraction?["name"] as? String
    }
    
    func viewInit() {
         navButton.image = #imageLiteral(resourceName: "nav_button")
        
        let navtap = UITapGestureRecognizer(target: self, action: #selector(didTapNavButton))
        navButton.isUserInteractionEnabled = true
        navButton.addGestureRecognizer(navtap)
        
        let closetap = UITapGestureRecognizer(target: self, action: #selector(closeProfile))
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(closetap)
    }
    
}
