//
//  StartTourController.swift
//  Kwento
//
//  Created by Richtone Hangad on 11/4/19.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import AudioIndicatorBars
import AVFoundation
import CoreData


class StartTourController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var attractionName: UILabel!
    @IBOutlet var playButton: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: MDCFlatButton!
    @IBOutlet var duration: UILabel!
    var audioPlayer = AVAudioPlayer()
    var downloadedFiles = [DownloadedFiles]()
    let dataService = CoreDataServices()
    var downloadedAttraction = [DownloadedAttractionDetails]()
    let dataServices = CoreDataServices()
    var sessionService = SessionServices()
    var language = ""
    var id = ""
    var name = ""
    var imageName = ""
    var sessionId = ""
    var durationVal = ""
    var attractionService = AttractionServices()
    var audioId : [String] = []
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
        
        attractionService.getAttractionById(id: id, completion: { result in
            var subAttraction = result?["sub_attractions"] as? [[String:Any]]
            
            subAttraction?.forEach({ item in
                var currentItem = item as? [String:Any]
               
                var filename = self.language == "English" ? currentItem?["audio_filename"] as? String : currentItem?["audio_filename_ph"] as? String
               
                self.audioId.append("\(filename!).mp3")
            })
            
            self.playMusic(audioFilename: self.audioId[0])
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "startToSelection" {
            if let destinationVC = segue.destination as? SelectionController {
                destinationVC.id = self.id
                destinationVC.sessionId = self.sessionId
                destinationVC.durationVal = self.durationVal
                destinationVC.attractionName = self.name
                destinationVC.imageName = self.imageName
                destinationVC.language = self.language
                destinationVC.audioId = self.audioId
            }
        }
        if segue.identifier == "toReview" {
            if let destinationVC = segue.destination as? RatingController {
                destinationVC.id = self.id
                destinationVC.attractionName = self.name
                destinationVC.imageName = self.imageName
            }
        }
    }


    
    func initViews() {
        startButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
        self.background.image = PublicData.getSavedImage(named: "\(imageName).png")
        self.attractionName.text = self.name
        self.background.contentMode = .scaleAspectFill
        
        let playGesture = UITapGestureRecognizer(target: self, action: #selector(playIntro(tapGestureRecognizer:)))
        playButton.isUserInteractionEnabled = true
        playButton.addGestureRecognizer(playGesture)
        
        getHoursOrMin()
    }
    
    @objc func playIntro(tapGestureRecognizer: UITapGestureRecognizer)
    {
       if audioPlayer.isPlaying {
           playButton.image = #imageLiteral(resourceName: "round_play_circle_outline_white_48pt")
           audioPlayer.pause()
       }
       else {
           playButton.image = #imageLiteral(resourceName: "round_pause_circle_outline_white_48pt")
           audioPlayer.play()
       }
    }
    
    func getSavedMp3(named: String) -> String? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
        }
        return nil
    }
    
    func playMusic(audioFilename : String) {
           var stringURL = getSavedMp3(named: String(audioFilename))
           print(stringURL)
           let url = URL(string: stringURL!)
           let audio = Bundle.main.path(forResource: "Moon River", ofType: "mp3")
   
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: url!)
           }
           catch {
               print(error)
           }
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
        audioPlayer.stop()
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
        self.performSegue(withIdentifier: "toReview", sender: nil)
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
