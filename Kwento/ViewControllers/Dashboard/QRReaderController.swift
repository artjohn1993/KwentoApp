//
//  QRReaderController.swift
//  Kwento
//
//  Created by Richtone Hangad on 16/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import Network

class QRReaderController: UIViewController {
    
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var scannerView: QRScannerView!
    var id = ""
    var attractionName = ""
    var imageName = ""
    var audioName = ""
    let dataService = CoreDataServices()
    let service = AttractionServices()
    var mainNavigationController: MainNavigationController!
    var connectionService = ConnectionService()
    var isConnected = false
    var language = ""
    //var context : QRReaderController
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //context = self
        print("something in qr viewcontroller")
//        NotificationCenter.default.addObserver(self, selector: #selector(proceed(_:)), name: NSNotification.Name("proceed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.proceed(_:)), name: NSNotification.Name(rawValue: "proceed"), object: nil)
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
        
        connectionService.checkConnection(completion: { connection in
            self.isConnected = connection
        }) 
    }
    
    @objc private func proceed(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let lang = dict["language"] as? String{
                print(lang)
                self.language = lang
                performSegue(withIdentifier: "qrToDownload", sender: nil)
            }
        }
        
    }
    @IBAction func closeEvent(_ sender: Any) {
        mainNavigationController.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.afterScan(str: "12")
        //performSegue(withIdentifier: "qrToStart", sender: nil)
//        performSegue(withIdentifier: "readerToLanguageSetting", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "qrToDownload" {
            if let destinationVC = segue.destination as? DownloadStoriesController {
                destinationVC.id = self.id
                destinationVC.language = self.language
            }
        }
        if segue.identifier == "qrToStart" {
            if let destinationVC = segue.destination as? SingleTourController {
                destinationVC.id = self.id
                destinationVC.name = self.attractionName
                destinationVC.imageName = self.imageName
                destinationVC.audioName = self.audioName
                destinationVC.language = self.language
            }
        }
    }
    
    
    @IBAction func didTapNavButton(_ sender: Any) {
        mainNavigationController.setDrawerState()
    }
    
    private func initViews() {
        navButton.image = #imageLiteral(resourceName: "nav_button")
        scannerView.delegate = self
        scannerView.startScanning()
        scannerView.layer.cornerRadius = 16
    }
    
    func afterScan(str : String) {
        self.id = str
        
        service.getAttractionById(id: str, completion: { result in
            print("request getAttractionById is done")
            self.attractionName = result?["name"] as? String ?? ""
            self.imageName = result?["image_filename"] as? String ?? ""
            self.audioName = self.language == "English" ? result?["audio_filename"] as? String ?? "" : result?["audio_filename_ph"] as? String ?? ""
            var subAttraction = result?["sub_attractions"] as? [[String:Any]]
            
            if subAttraction?.count ?? 0 > 0 {
                //self.performSegue(withIdentifier: "qrToDownload", sender: nil)
                self.performSegue(withIdentifier: "readerToLanguageSetting", sender: nil)
            }
            else {
                self.service.downloadImage(idImage: self.imageName, completion: { percentage in
                    if percentage == 1 {
                        self.performSegue(withIdentifier: "qrToStart", sender: nil)
                    }
                })
            }
        })
    }
    
}

extension QRReaderController: QRScannerViewDelegate {
    
    func qrScanningDidFail() {
        let alert = UIAlertController(title: "Error", message: "Can't access camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        
        if isConnected {
            self.afterScan(str: str!)
        }
        else {
            PublicData.showSnackBar(message: "Not Connected")
        }
        
    }
    
    func qrScanningDidStop() {
//        let alert = UIAlertController(title: "Error", message: "Camera closed", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
//            alert.dismiss(animated: true)
//        }))
//        present(alert, animated: true)
    }
    
    
}
