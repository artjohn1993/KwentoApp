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
    
    var downloadedFiles = [DownloadedFiles]()
    var downloadedAttraction = [DownloadedAttractionDetails]()
    let dataServices = CoreDataServices()
    var sessionService = SessionServices()
    var id = ""
    var name = ""
    var imageName = ""
    var sessionId = ""
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapYes), name: NSNotification.Name("endTour"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "startToPlayer" {
            if let destinationVC = segue.destination as? AudioPlayerController {
                destinationVC.id = self.id
            }
        }
    }
    
    func initViews() {
        startButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        self.background.image = PublicData.getSavedImage(named: "\(imageName).png")
        self.attractionName.text = self.name
        self.background.contentMode = .scaleAspectFill
    }
    
    @IBAction func start(_ sender: Any) {
        if self.sessionId == "" {
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
        self.sessionService.endSession()
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
