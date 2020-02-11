//
//  DownloadStoriesController.swift
//  Kwento
//
//  Created by Richtone Hangad on 24/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents
import Alamofire

class DownloadStoriesController: UIViewController {

    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cancelButton: MDCFlatButton!
    
    var service = AttractionServices()
    var id = ""
    var attractionName = ""
    var imageName = ""
    var totalItemToDownload = 0
    var mainNavigationController: MainNavigationController!
    var connectionService = ConnectionService()
    var isConnected = false
    var duration = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("id from download:\(id)")
        
        mainNavigationController = navigationController as? MainNavigationController
        initViews()
        
        
        connectionService.checkConnection(completion: { connection in
            print(connection)
            if connection {
                print("resume")
                DispatchQueue.main.async {
                    self.progressText.text = "0%"
                    self.progressView.setProgress(0, animated: true)
                }
                if !self.isConnected {
                    self.isConnected = true
                    self.downloadFile()
                }
                
            }
            else {
                print("suspend")
                if self.isConnected {
                    self.isConnected = false
                    self.service.request?.suspend()
                }
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapYes), name: NSNotification.Name("didTapYes"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "downloadToStart" {
            if let destinationVC = segue.destination as? StartTourController {
                destinationVC.id = self.id
                destinationVC.name = self.attractionName
                destinationVC.imageName = self.imageName
                destinationVC.durationVal = self.duration
            }
        }
    }
    
    @IBAction func cancelRequest(_ sender: Any) {
//       print("cancel request")
//       stopRequests()
//       mainNavigationController.popViewController(animated: true)
        
        self.performSegue(withIdentifier: "cancelDownloadDialog", sender: nil)
    }
    
    func stopRequests(){
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
            }
        }
    }
    
    func pauseRequest() {
        print("PAUSE REQUEST")
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.suspend() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.suspend() }
                uploadData.forEach { $0.suspend() }
                downloadData.forEach { $0.suspend() }
            }
        }
    }
    
    func resumeRequest() {
        print("RESUME REQUEST")
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.resume() }
            }
        } else {
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.resume() }
                uploadData.forEach { $0.resume() }
                downloadData.forEach { $0.resume() }
            }
        }
    }
    
    func downloadFile() {
        service.getAttractionById(id: id, completion: { result in
            let subAttraction = result?["sub_attractions"] as? [[String: Any]]
            self.totalItemToDownload = (subAttraction != nil) ? subAttraction!.count : 0
            let image = result?["image_filename"] as? String
            self.duration = result?["total_duration"] as? String ?? ""
            self.imageName = image ?? ""
            self.attractionName = result?["name"] as? String ?? ""
            
            if image != nil {
                
                self.totalItemToDownload += 1
                print("totalItemToDownload:\(self.totalItemToDownload)")
                self.service.downloadImage(idImage: image!, completion: { percentage in
                    let constantPercent = 1/Float(self.totalItemToDownload)
                    var downloadPercentage = percentage * constantPercent
                    self.progressView.setProgress(downloadPercentage, animated: true)
                    let percent = Int(100 * downloadPercentage)
                    self.progressText.text = "\(percent)%"
                    
                    if percentage == 1.0 {
                        self.downloadAudio(data: subAttraction!, index: 0,constant: constantPercent, currentPercent : constantPercent)
                    }
                })
            }
            
        })
    }
    
    
    func downloadAudio(data : [[String: Any]],index: Int,constant: Float, currentPercent : Float) {
        var current = index
        let audioId = data[current]["audio_filename"] as? String
        
        self.service.downloadAudio(idAudio: audioId!, completion: { percentage in
            
            var downloadPercentage = (percentage * constant) + currentPercent
            self.progressView.setProgress(downloadPercentage, animated: true)
            let percent = Int(100 * downloadPercentage)
            self.progressText.text = "\(percent)%"
            
            if percent == 100 {
                self.progressText.text = "100%"
                self.progressView.setProgress(1, animated: true)
                self.performSegue(withIdentifier: "downloadToStart", sender: nil)
            }
            else {
                if percentage == 1 {
                    self.downloadAudio(data: data, index: current + 1,constant: constant, currentPercent : currentPercent + constant)
                }
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.performSegue(withIdentifier: "downloadToStart", sender: nil)
    }
    
    func initViews() {
        progressView.layer.cornerRadius = progressView.frame.size.height / 2
        cancelButton.initialize(backgroundColor: .mainDark, titleColor: .white, cornerRadius: 4)
    }
    
    @objc func didTapYes() {
        stopRequests()
        mainNavigationController.popViewController(animated: true)
    }

}
