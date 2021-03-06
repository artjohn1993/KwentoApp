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

class AudioPlayerController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var indicator: AudioIndicatorBarsView!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var skipPreviousButton: UIButton!
    @IBOutlet weak var skipNextButton: UIButton!
    
    var mainNavigationController: MainNavigationController!
    
    var audioPlayer = AVAudioPlayer()
    var id = ""
    var language = ""
    var service = AttractionServices()
    var currentTime: TimeInterval!
    var downloadedAttraction = [DownloadedAttractionDetails]()
    var audioId : [String] = []
    var musicIndex = 0
    var sessionService = SessionServices()
    var isOutOfIndex = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("audio player:\(id)")
         print("musicIndex:\(musicIndex)")
//        service.getAttractionById(id: id, completion: { result in
//            var subAttraction = result?["sub_attractions"] as? [[String:Any]]
//
//            subAttraction?.forEach({ item in
//                var currentItem = item as? [String:Any]
//                var filename = self.language == "English" ? currentItem?["audio_filename"] as? String : currentItem?["audio_filename_ph"] as? String
//                print("filename:\(filename)")
//                self.audioId.append("\(filename!).mp3")
//            })
//
//            self.playMusic(audioFilename: self.audioId[self.musicIndex])
//            self.setInit()
//        })
        self.playMusic(audioFilename: self.audioId[self.musicIndex])
        self.setInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialView()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if musicIndex >= 0 && musicIndex < audioId.count {
//            musicIndex += 1
//            print("if")
//            print(musicIndex)
//            playMusic(audioFilename: audioId[musicIndex])
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
//        else {
//            musicIndex = 0
//            print("else")
//            print(musicIndex)
//            playMusic(audioFilename: audioId[musicIndex])
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
        indicator.stop()
        playButton.setImage(#imageLiteral(resourceName: "round_play_circle_outline_white_48pt"), for: .normal)
    }
    
    func setInit() {
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
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
    
    func getSavedMp3(named: String) -> String? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
        }
        return nil
    }
    
    func initialView() {
        playButton.fillIcon()
        skipPreviousButton.fillIcon()
        skipNextButton.fillIcon()
    }
    
    func initViews() {
        audioPlayer.delegate = self as! AVAudioPlayerDelegate
        
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

    @IBAction func playPause(_ sender: Any) {
        if !isOutOfIndex {
            if audioPlayer.isPlaying {
                playButton.setImage(#imageLiteral(resourceName: "round_play_circle_outline_white_48pt"), for: .normal)
                audioPlayer.pause()
                indicator.stop()
                currentTime = audioPlayer.currentTime
            }
            else {
                playButton.setImage(#imageLiteral(resourceName: "round_pause_circle_outline_white_48pt"), for: .normal)
                audioPlayer.play()
                indicator.start()
            }
        }
        else {
            PublicData.showSnackBar(message: "Invalid  index")
        }
    }
    
    @IBAction func skipPrevious(_ sender: Any) {
        
//        if musicIndex > 0 {
//            musicIndex -= 1
//            print("if")
//            print(musicIndex)
//            playMusic(audioFilename: audioId[musicIndex])
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
//        else {
//            musicIndex = audioId.count - 1
//            print("else")
//            print(musicIndex)
//            playMusic(audioFilename: audioId[musicIndex])
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
    }
    
    @IBAction func skipNext(_ sender: Any) {
//        if musicIndex >= 0 && musicIndex < audioId.count - 1 {
//            musicIndex += 1
//            print("if")
//            print(musicIndex)
//            playMusic(audioFilename: audioId[musicIndex])
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//
//        }
//        else {
//            musicIndex = 0
//            print("else")
//            print(musicIndex)
//            playMusic(audioFilename: audioId[musicIndex])
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
    }
}


