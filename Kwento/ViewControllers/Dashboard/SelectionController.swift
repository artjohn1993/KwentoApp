//
//  SelectionController.swift
//  Kwento
//
//  Created by Art John on 03/02/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit

class SelectionController: UIViewController {
    var mainNavigationController: MainNavigationController!
    var sessionService = SessionServices()
    var service = AttractionServices()
    @IBOutlet var logo: UIImageView!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var container: UIView!
    var id = ""
    var sessionId = ""
    var durationVal = ""
    var audioId : [String] = []
    @IBOutlet var duration: UILabel!
    
    
    @IBOutlet var endButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("id:\(id)")
        print("sessionId:\(sessionId)")
        initView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectionToPlayer" {
            if let destinationVC = segue.destination as? AudioPlayerController {
                destinationVC.musicIndex = Int(numberField.text!)!
                destinationVC.id = self.id
            }
        }
    }
    
    func initView() {
        logo.image = #imageLiteral(resourceName: "globe")
        
        container.layer.cornerRadius = 5
        
        numberField.layer.cornerRadius = 5
        numberField.layer.borderWidth = 0
        
        let conViewGesture = UITapGestureRecognizer(target: self, action: #selector(endButtonEVent))
        endButton.isUserInteractionEnabled = true
        endButton.addGestureRecognizer(conViewGesture)
        
        mainNavigationController = navigationController as? MainNavigationController
        
        getHoursOrMin()
        getAttractionById()
    }
    
    func getAttractionById() {
        self.service.getAttractionById(id: self.id, completion: { result in
            var subAttraction = result?["sub_attractions"] as? [[String:Any]]

            subAttraction?.forEach({ item in
                var currentItem = item as? [String:Any]
                var filename = currentItem?["audio_filename"] as? String
                self.audioId.append("\(filename!).mp3")
            })
        })
    }
    
    func checkIndex(index: Int) -> Bool {
        if audioId.get(at: index) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func getHoursOrMin() {
        var arrayTime = durationVal.components(separatedBy: ":")
        print(arrayTime[0])
        print(arrayTime[1])
        
        if arrayTime[0] == "00" {
            duration.text = "Tour ends in \(arrayTime[1]) minutes"
        }
        else {
            if arrayTime[0] != "01" {
                duration.text = "Tour ends in \(arrayTime[0]) hour"
            }
            else {
                duration.text = " Tour ends in \(arrayTime[0]) hours"
            }
        }
    }
    
    @objc
    func endButtonEVent(sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "endTour", sender: nil)
    }
    
    @objc func endTour() {
        print("@objc func endTour()'")
        self.sessionService.endSession()
        self.mainNavigationController.popToRootViewController(animated: true)

    }
    
    @IBAction func oneEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)1"
    }
    
    @IBAction func twoEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)2"
    }
    @IBAction func threeEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)3"
    }
    @IBAction func fourEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)4"
    }
    @IBAction func fiveEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)5"
    }
    @IBAction func sixEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)6"
    }
    @IBAction func sevenEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)7"
    }
    @IBAction func eightEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)8"
    }
    @IBAction func nineEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)9"
    }
    @IBAction func zeroEvent(_ sender: Any) {
        numberField.text = "\(numberField.text!)0"
    }
    @IBAction func deleteEvent(_ sender: Any) {
        if numberField.text != "" {
            numberField.text?.removeLast()
        }
    }
    
    @IBAction func playEvent(_ sender: Any) {
        
        if numberField.text != "" {
            if checkIndex(index: Int(numberField.text!)!) {
                self.performSegue(withIdentifier: "selectionToPlayer", sender: nil)
            }
            else {
                PublicData.showSnackBar(message: "Invalid index")
            }
        }
    }
    
    
    
    @IBAction func navEvent(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closeEvent(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
    }
}

extension Collection {
    func get(at index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
