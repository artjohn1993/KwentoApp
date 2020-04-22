//
//  SingleTourController.swift
//  Kwento
//
//  Created by Art John on 03/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import AVFoundation
import AudioIndicatorBars
import CoreData

class SingleTourController : UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var attractionName: UILabel!
    @IBOutlet weak var audioIndicator: AudioIndicatorBarsView!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
   // @IBOutlet weak var nextButton: UIButton!
   // @IBOutlet weak var prevButton: UIButton!
    
    let service = AttractionServices()
    let sessionService = SessionServices()
    var mainNavigationController: MainNavigationController!
    var audioPlayer = AVAudioPlayer()
    var id = ""
    var language = ""
    var sessionId = ""
    var name = ""
    var imageName = ""
    var audioName = ""
    let publicData = PublicData()
    let dataService = CoreDataServices()
    var currentTime: TimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background.image = PublicData.getSavedImage(named: self.imageName)
        self.background.contentMode = .scaleAspectFill
        self.attractionName.text = self.name

        self.dataService.getSession(completion: { result in
            print("session total:\(result?.count)")
        })

        if sessionId == "" {
            //dataService.saveActiveSession(id: id)
            sessionService.startSession(id: id, completion: {

            })

            PublicData.spinnerAlert(controller: self)
            downloadAudio()
        }
        else {
            setMp3Player()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(endTour), name: NSNotification.Name("endTour"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview" {
            if let destinationVC = segue.destination as? RatingController {
                destinationVC.id = self.id
                destinationVC.attractionName = self.name
                destinationVC.imageName = self.imageName
            }
        }
        
    }
    
    func downloadAudio() {
        service.downloadAudio(idAudio: audioName, completion: { result in
                    print("\(result)==\(1.0)")
                    
                    if result == 1.0 {
                        print("inside result condition")
                        PublicData.removeSpinnerAlert(controller: self)
                        self.setMp3Player()
                    }
                })
    }
    
    func setMp3Player() {
        print("setMp3Player")
        var stringURL = self.getSavedMp3(named: "\(self.audioName).mp3")
        let url = URL(string: stringURL!)
        print(url!)
                let audio = Bundle.main.path(forResource: "Moon River", ofType: "mp3")

        do {
            if url != nil {
                print("url has data")
                self.audioPlayer = try AVAudioPlayer(contentsOf: url!)
                self.initViews()
                self.mainNavigationController = self.navigationController as? MainNavigationController
            }
            else {
                print("url is nil")
            }
        }
        catch {
            print(error)
            PublicData.spinnerAlert(controller: self)
            downloadAudio()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        sessionService.endSession()
    }
    
    func getSavedMp3(named: String) -> String? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
        }
        return nil
    }
    
    func initViews() {
        playButton.fillIcon()
//        prevButton.fillIcon()
//        nextButton.fillIcon()
        audioPlayer.delegate = self as! AVAudioPlayerDelegate
        audioSlider.maximumValue = Float(audioPlayer.duration)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.audioSlider.value = Float(self.audioPlayer.currentTime)
        }
        
    }
    
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            playButton.setImage(#imageLiteral(resourceName: "round_pause_circle_outline_white_48pt"), for: .normal)
            audioPlayer.currentTime = TimeInterval(exactly: sender.value)!
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        else {
            audioPlayer.stop()
            audioPlayer.currentTime = TimeInterval(exactly: sender.value)!
            playButton.setImage(#imageLiteral(resourceName: "round_play_circle_outline_white_48pt"), for: .normal)
        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        if audioPlayer.isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "round_play_circle_outline_white_48pt"), for: .normal)
            audioPlayer.pause()
            audioIndicator.stop()
            currentTime = audioPlayer.currentTime
        }
        else {
            playButton.setImage(#imageLiteral(resourceName: "round_pause_circle_outline_white_48pt"), for: .normal)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            audioIndicator.start()
        }
    }
    
    @IBAction func didTapNav(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closePlayer(_ sender: Any) {
       self.performSegue(withIdentifier: "endTour", sender: nil)
    }
    
    @objc func endTour() {
        audioPlayer.stop()
        self.performSegue(withIdentifier: "toReview", sender: nil)
    }
}
