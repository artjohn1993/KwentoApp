//
//  QRReaderController.swift
//  Kwento
//
//  Created by Richtone Hangad on 16/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class QRReaderController: UIViewController {
    
    @IBOutlet weak var navButton: UIImageView!
    @IBOutlet weak var scannerView: QRScannerView!
    var id = ""
    let dataService = CoreDataServices()
    var mainNavigationController: MainNavigationController!
    //var context : QRReaderController
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //context = self
        NotificationCenter.default.addObserver(self, selector: #selector(proceed), name: NSNotification.Name("proceed"), object: nil)
        initViews()
        mainNavigationController = navigationController as? MainNavigationController
    }
    
    @objc private func proceed() {
        performSegue(withIdentifier: "qrToDownload", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //performSegue(withIdentifier: "qrToDownload", sender: nil)
//        performSegue(withIdentifier: "readerToLanguageSetting", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "qrToDownload" {
            if let destinationVC = segue.destination as? DownloadStoriesController {
                destinationVC.id = self.id
            }
        }
        if segue.identifier == "qrToStart" {
            if let destinationVC = segue.destination as? StartTourController {
                destinationVC.id = self.id
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
        
        let allAttraction = dataService.getAllAttraction(completion: { response in
            
            response?.forEach({ item in
                
                if item.id == str {
                    if item.sub_attractions {
                        self.id = str ?? ""
                        self.performSegue(withIdentifier: "readerToLanguageSetting", sender: nil)
                    }
                    else {
                         self.id = str ?? ""
                         self.performSegue(withIdentifier: "qrToStart", sender: nil)
//                        print("wala siyay sub attraction")
//                        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "startTourController") as! StartTourController
//                        vc.id = str ?? ""
//                        self.present(vc, animated: true, completion: nil)
                    }
                }
            })
            
        })
        
//        let alert = UIAlertController(title: "Code", message: str, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
//            alert.dismiss(animated: true)
//            print(str)
//            self.id = str ?? ""
//
//
//            self.performSegue(withIdentifier: "readerToLanguageSetting", sender: nil)
//
//
//            self.scannerView.startScanning()
//        }))
//        present(alert, animated: true)
        
    }
    
    func qrScanningDidStop() {
//        let alert = UIAlertController(title: "Error", message: "Camera closed", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
//            alert.dismiss(animated: true)
//        }))
//        present(alert, animated: true)
    }
    
    
}
