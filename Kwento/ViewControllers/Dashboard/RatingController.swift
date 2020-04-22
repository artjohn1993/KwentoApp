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
    //@IBOutlet weak var navButton: UIImageView!
    //@IBOutlet weak var closeButton: UIImageView!
    let profileService = ProfileServices()
    var mainNavigationController: MainNavigationController!
    let sessionService = SessionServices()
    var attractionService = AttractionServices()
    var rate = 0
    var id = ""
    var attractionName = ""
    var userId = 0
    var imageName = ""
    
    override func viewDidLoad() {
    super.viewDidLoad()
        print(id)
        print(attractionName)
        mainNavigationController = navigationController as? MainNavigationController
        viewInit()
        
        profileService.getCurrentUser(completion: { result in
            var data = result as? [String:Any]
            self.userId = data?["id"]! as? Int ?? 0
        })
        
        rating.didFinishTouchingCosmos = { rate in
            print(rate)
            self.rate = Int(rate)
        }
    }
    
    @objc func didTapNavButton() {
        mainNavigationController.setDrawerState()
    }
    
    @objc func closeProfile() {
        mainNavigationController.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        //let userId = visit[index]["user_id"] as? Int
        
        let parameters: Parameters = [
            "attraction_id" : self.id,
            "user_id" : self.userId,
            "rating" : rate,
            "review_text": message.text,
            "attraction" : self.attractionName
        ]
        
        visitService.rate(parameter: parameters, completion: { result in
            self.mainNavigationController.popToRootViewController(animated: true)
            self.sessionService.endSession()
        })
       
    }
    
    func setView() {
        
        
        let image = self.imageName as! String
        var imageChecker = PublicData.getSavedImage(named: "\(image).png")
        print(imageChecker)
        if imageChecker == nil {
            if image != nil {
                attractionService.downloadImage(idImage: image, completion: { result in
                    print("set Image")
                    print(image)
                    self.imageLocation.image = PublicData.getSavedImage(named: "\(image).png")
                })
            }
        }
        else {
            print("wala na ni download")
            self.imageLocation.image = PublicData.getSavedImage(named: "\(image).png")
        }

        locationName.text = attractionName
    }
    
    func viewInit() {
         //navButton.image = #imageLiteral(resourceName: "nav_button")
        
        //let navtap = UITapGestureRecognizer(target: self, action: #selector(didTapNavButton))
        //navButton.isUserInteractionEnabled = true
        //navButton.addGestureRecognizer(navtap)
        
        //let closetap = UITapGestureRecognizer(target: self, action: #selector(closeProfile))
        //closeButton.isUserInteractionEnabled = true
        //closeButton.addGestureRecognizer(closetap)
        
        message.layer.borderWidth = 1
        message.layer.borderColor = UIColor.black.cgColor
        
        rating.rating = Double(rate)
        
        setView()
    }
    
}
