//
//  DownloadStoriesController.swift
//  Kwento
//
//  Created by Richtone Hangad on 24/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class DownloadStoriesController: UIViewController {

    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cancelButton: MDCFlatButton!
    
    var service = AttractionServices()
    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressText.text = "0%"
        initViews()
        service.getAttractionById(id: id!, completion: { result in
            self.progressView.setProgress(result, animated: true)
            let percent = Int(100 * result)
            self.progressText.text = "\(percent)%"
            print("\(percent)%")
            
            if percent == 100 {
                self.performSegue(withIdentifier: "downloadToStart", sender: nil)
            }
        })
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //performSegue(withIdentifier: "downloadToStart", sender: nil)
    }
    
    func initViews() {
        progressView.layer.cornerRadius = progressView.frame.size.height / 2
        cancelButton.initialize(backgroundColor: .mainDark, titleColor: .white, cornerRadius: 4)
    }

}
