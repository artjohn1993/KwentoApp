//
//  CancelTourController.swift
//  Kwento
//
//  Created by Art John on 02/01/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit

class CancelTourController: UIViewController {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    private func setView() {
        yesButton.layer.cornerRadius = 5
        noButton.layer.cornerRadius = 5
        logo.image = #imageLiteral(resourceName: "cancel_logo")
    }
    
    @IBAction func didTapYes(_ sender: Any) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("didTapYes"), object: nil)
    }
    
    @IBAction func didTapNo(_ sender: Any) {
        dismiss(animated: true)
    }
}
