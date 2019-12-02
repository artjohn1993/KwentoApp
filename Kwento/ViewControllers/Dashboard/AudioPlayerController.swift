//
//  AudioPlayerController.swift
//  Kwento
//
//  Created by Richtone Hangad on 11/6/19.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import AVFoundation
import AudioIndicatorBars
import CoreData

class AudioPlayerController: UIViewController {
    
    @IBOutlet weak var indicator: AudioIndicatorBarsView!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipPreviousButton: UIButton!
    @IBOutlet weak var skipNextButton: UIButton!
    
    var mainNavigationController: MainNavigationController!
    
    var audioPlayer = AVAudioPlayer()
    
    var currentTime: TimeInterval!
    var downloadedAttraction = [DownloadedAttractionDetails]()
    let dataServices = CoreDataServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataServices.getDownloadedAttraction(completion: { result in
                   self.downloadedAttraction = result ?? []
        })
        let audioFilename = "\(self.downloadedAttraction[0].audioFilename!).mp3"
//        let range = audioFilename.range(of: ".mp3")!
//        let title = audioFilename[audioFilename.startIndex..<range.lowerBound]
//        print("checking the title-------------------------------")
//        print(title)
        var stringURL = getSavedMp3(named: String(audioFilename))
        print(stringURL)
        let url = (stringURL != nil) ? URL(string: stringURL!) : nil
        print("url:\(url!)")
        let audio = Bundle.main.path(forResource: "Moon River", ofType: "mp3")
        
        do {
            if url != nil {
                print("if")
                audioPlayer = try AVAudioPlayer(contentsOf: url!)
            }
            else {
                print("else")
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audio!))
            }
            
        }
        catch {
            print(error)
        }
        
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        
        
    }
    
    func getSavedMp3(named: String) -> String? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
        }
        return nil
    }
    
    func initViews() {
        playButton.fillIcon()
        skipPreviousButton.fillIcon()
        skipNextButton.fillIcon()
        
        audioSlider.maximumValue = Float(audioPlayer.duration)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.audioSlider.value = Float(self.audioPlayer.currentTime)
        }
    }
    
    @IBAction func didTapNavButton(_ sender: UIButton) {
        mainNavigationController.setDrawerState()
    }
    
    @IBAction func closeAudioPlayer(_ sender: Any) {
        audioPlayer.stop()
        mainNavigationController.popViewController(animated: true)
    }
    
    @IBAction func sliderValueDidChanged(_ sender: UISlider) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(exactly: sender.value)!
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    @IBAction func playPause(_ sender: Any) {
        if audioPlayer.isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "round_play_circle_outline_white_48pt"), for: .normal)
            audioPlayer.pause()
            indicator.stop()
            currentTime = audioPlayer.currentTime
        }
        else {
            playButton.setImage(#imageLiteral(resourceName: "round_pause_circle_outline_white_48pt"), for: .normal)
//            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            indicator.start()
        }
    }
    
    @IBAction func skipPrevious(_ sender: Any) {
        
    }
    
    @IBAction func skipNext(_ sender: Any) {
        
    }
}
