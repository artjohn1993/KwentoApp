//
//  PublicData.swift
//  Kwento
//
//  Created by Art John on 22/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import MaterialComponents.MaterialSnackbar

class PublicData {
    static let baseUrl = "http://13.67.42.99"
    static let clientId = "Kwento_iOS"
    static let client_secret = "06f72a69-473d-4b4c-90c6-8b610359dffe"
    var vSpinner : UIView?
    
    init() {
        vSpinner = nil
    }
    
    func showSpinner(onView : UIView) {
        print("showSpinner")
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        self.vSpinner = spinnerView
    }
    
    static func spinnerAlert(controller : UIViewController) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func removeSpinnerAlert(controller : UIViewController) {
        controller.dismiss(animated: false, completion: nil)
    }
    
    func removeSpinner() {
        print("removeSpinner")
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    static func showSnackBar(message : String) {
        let content = MDCSnackbarMessage()
        content.text = message
        MDCSnackbarManager.show(content)
    }
    
    static func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
