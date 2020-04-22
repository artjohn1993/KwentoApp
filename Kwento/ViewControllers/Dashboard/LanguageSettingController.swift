//
//  LanguageSettingController.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/09/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class LanguageSettingController: UIViewController {
    
    @IBOutlet weak var popupView: MDCCard!
    
    @IBOutlet weak var englishButton: KGRadioButton!
    @IBOutlet weak var tagalogButton: KGRadioButton!
    
    @IBOutlet weak var proceedButton: MDCFlatButton!
    @IBOutlet weak var cancelButton: MDCFlatButton!
    
    var id: String?
    var language: [String: String] = ["language" : "English"]
    //var parentController: QRReaderController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
    }
    
    private func initViews() {
        popupView.layer.cornerRadius = 12
        popupView.setShadowElevation(.menu, for: .normal)
        proceedButton.initialize(backgroundColor: UIColor(rgb: 0x11CFC8), titleColor: .white, cornerRadius: 4)
        cancelButton.initialize(backgroundColor: UIColor(rgb: 0x11CFC8).withAlphaComponent(0.34), titleColor: UIColor(rgb: 0x11CFC8), cornerRadius: 4)
    }
    
    @IBAction func didSelectEnglish(_ sender: Any) {
        englishButton.outerCircleLineWidth = 4
        tagalogButton.outerCircleLineWidth = 1
        language = ["language" : "English"]
    }
    
    @IBAction func didSelectTagalog(_ sender: Any) {
        tagalogButton.outerCircleLineWidth = 4
        englishButton.outerCircleLineWidth = 1
        language = ["language" : "Tagalog"]
    }
    
    @IBAction func proceed(_ sender: Any) {
        dismiss(animated: true)
        
//        NotificationCenter.default.post(name: NSNotification.Name("proceed"), object: nil, lang: language)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "proceed"), object: nil, userInfo: language)
        
        //performSegue(withIdentifier: "settingToDownload", sender: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
