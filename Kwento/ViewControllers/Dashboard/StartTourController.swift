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
    var id = ""
    
    
    var mainNavigationController: MainNavigationController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("id:\(id)")
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        
        if id != "" {
            self.setDataWithoutSub()
        }
        else {
            dataServices.getDownloadedFiles(completion: { result in
                self.downloadedFiles = result ?? []
                print(self.downloadedFiles)
                
                
                self.dataServices.getDownloadedAttraction(completion: { result in
                    self.downloadedAttraction = result ?? []
                    print(self.downloadedAttraction)
                    self.setDataWithSub()
                })
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "startToPlayer" {
            if let destinationVC = segue.destination as? AudioPlayerController {
                destinationVC.id = self.id
            }
        }
    }
    
    func setDataWithSub() {
        print("SET setDataWithSub")
        if self.downloadedAttraction.count > 0 {
            self.attractionName.text = self.downloadedAttraction[0].name
            print("\(self.downloadedAttraction[0].imageFilename!).png")
            self.background.image = PublicData.getSavedImage(named: "\(self.downloadedAttraction[0].imageFilename!).png")
        }
    }
    
    func setDataWithoutSub() {
        print("SET setDataWithoutSub")
        dataServices.getAllAttraction(completion: { response in
            response?.forEach({ item in
                print("\(item.name!) : \(item.id!) == \(self.id)")
                if item.id! == self.id {
                    self.attractionName.text = item.name
                    self.background.image = PublicData.getSavedImage(named: "\(item.image_filename!).png")
                }
            })
        })
    }
    
    func initViews() {
        startButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        self.background.contentMode = .scaleAspectFill
    }
    
    @IBAction func start(_ sender: Any) {
        print("hey yow!!!")
        //performSegue(withIdentifier: "startToPlayer", sender: nil)
    }
    
    @IBAction func didTapNavButton(_ sender: UIButton) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closeTour(_ sender: Any) {
        mainNavigationController.popToRootViewController(animated: true)
    }
}
