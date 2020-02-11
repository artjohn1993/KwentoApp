//
//  StartTourController.swift
//  Kwento
//
//  Created by Richtone Hangad on 11/4/19.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class StartTourController: UIViewController {
    
    @IBOutlet weak var attractionName: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: MDCFlatButton!
    @IBOutlet var duration: UILabel!
    
    var downloadedFiles = [DownloadedFiles]()
    let dataService = CoreDataServices()
    var downloadedAttraction = [DownloadedAttractionDetails]()
    let dataServices = CoreDataServices()
    var sessionService = SessionServices()
    var id = ""
    var name = ""
    var imageName = ""
    var sessionId = ""
    var durationVal = ""
    
    var mainNavigationController: MainNavigationController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("start id:\(id)")
        print("start sessionId:\(sessionId)")
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        NotificationCenter.default.addObserver(self, selector: #selector(didTapYes), name: NSNotification.Name("didTapYes"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endTour), name: NSNotification.Name("endTour"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "startToSelection" {
            if let destinationVC = segue.destination as? SelectionController {
                destinationVC.id = self.id
                destinationVC.sessionId = self.sessionId
                destinationVC.durationVal = self.durationVal
            }
        }
    }
    

    
    func initViews() {
        startButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        self.background.image = PublicData.getSavedImage(named: "\(imageName).png")
        self.attractionName.text = self.name
        self.background.contentMode = .scaleAspectFill
        getHoursOrMin()
    }
    
    func getHoursOrMin() {
        print("getHoursOrMin")
        print(durationVal)
        var arrayTime = durationVal.components(separatedBy: ":")
        print(arrayTime[0])
        print(arrayTime[1])
        
        if arrayTime[0] == "00" {
            duration.text = "\(arrayTime[1]) minutes"
        }
        else {
            if arrayTime[0] != "01" {
                duration.text = "\(arrayTime[0]) hour"
            }
            else {
                duration.text = "\(arrayTime[0]) hours"
            }
        }
    }
    
    @IBAction func start(_ sender: Any) {
        if self.sessionId == "" {
           //dataService.saveActiveSession(id: self.id)
           sessionService.startSession(id: self.id, completion: {})
        }
        else {
            print("no need to start session again")
        }
        
    }
    
    @IBAction func didTapNavButton(_ sender: UIButton) {
        mainNavigationController.setDrawerState()
    }
    
    @objc func didTapYes() {
        mainNavigationController.popToRootViewController(animated: true)
    }
    
    @objc func endTour() {
        print("@objc func endTour()'")
        self.sessionService.endSession(sessionId : sessionId)
        self.mainNavigationController.popToRootViewController(animated: true)
    }
    
    @IBAction func closeTour(_ sender: Any) {
        //mainNavigationController.popToRootViewController(animated: true)
        
        dataServices.getSession(completion: { response in
            if response?.count ?? 0 > 0 {
                print("endTour")
                self.performSegue(withIdentifier: "endTour", sender: nil)
            }
            else {
                print("cancelTour")
                self.performSegue(withIdentifier: "cancelTour", sender: nil)
            }
        })
    }
}
