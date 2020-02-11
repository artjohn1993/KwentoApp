//
//  HomeController.swift
//  Kwento
//
//  Created by Richtone Hangad on 10/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import Pulsator
import Network

class HomeController: UIViewController {
    
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var outerCircle: UIView!
    
    let pulsator = Pulsator()
    var mainNavigationController: MainNavigationController!
    let connectionService = ConnectionService()
    let sessionService = SessionServices()
    let dataService = CoreDataServices()
    var id = ""
    var name = ""
    var imageName = ""
    var audioName = ""
    var sessionId = ""
    var duration = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home COntroller")
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapToDownload(sender:)))
        self.outerCircle.addGestureRecognizer(gesture)
        
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        
        connectionService.checkConnection(completion: { connection in
            if !connection {
                
                DispatchQueue.main.async {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "noConnectionID") as! NoConnectionDialogController
                    self.present(newViewController, animated: true, completion: nil)
                }

            }
            else {
                print("connection is back")
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true)
//                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = outerCircle.layer.position
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "homeToMultiple" {
            if let destinationVC = segue.destination as? StartTourController {
                destinationVC.id = self.id
                destinationVC.name = self.name
                destinationVC.imageName = self.imageName
                destinationVC.sessionId = self.sessionId
                destinationVC.durationVal = self.duration
            }
        }
        if segue.identifier == "homeToSingle" {
            if let destinationVC = segue.destination as? SingleTourController {
                destinationVC.id = self.id
                destinationVC.name = self.name
                destinationVC.imageName = self.imageName
                destinationVC.audioName = self.audioName
                destinationVC.sessionId = self.sessionId
            }
        }
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

    
    @objc func tapToDownload(sender: UITapGestureRecognizer) {
        print("tapToDownload")
        sessionService.getActiveSession(completion: { result in
            let attraction = result?["attraction"] as? [String:Any]
            let subAttraction = attraction?["sub_attractions"] as? [[String:Any]]
            self.id = result?["attraction_id"] as? Int != nil ? String(result?["attraction_id"] as! Int) : ""
            self.duration = attraction?["total_duration"] as? String ?? ""
            self.audioName = attraction?["audio_filename"] as? String ?? ""
            self.name = attraction?["name"] as? String ?? ""
            self.imageName = attraction?["image_filename"] as? String ?? ""
            self.sessionId = result?["id"] as? Int != nil ? String(result?["id"] as! Int) : ""
            print(self.sessionId)
            print(result?["id"] as? Int)
            print("duration:\(self.duration)")
            
            if result != nil {
 
                print(subAttraction?.count)
                if subAttraction?.count ?? 0 > 0 {
                    self.performSegue(withIdentifier: "homeToMultiple", sender: nil)
                }
                else {
                    self.performSegue(withIdentifier: "homeToSingle", sender: nil)
                }
            }
            else {
                self.performSegue(withIdentifier: "homeToQr", sender: nil)
            }
        })
    }
    
}
