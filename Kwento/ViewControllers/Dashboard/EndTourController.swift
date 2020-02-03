//
//  EndTourController.swift
//  Kwento
//
//  Created by Art John on 03/01/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit

class EndTourController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var endTourButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

       setView()
    }

    
    @objc
    func dismiss(sender:UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc
    func clickConView(sender:UITapGestureRecognizer) {
        
    }
    
    private func setView() {
        endTourButton.layer.cornerRadius = 5
       
        logo.image = #imageLiteral(resourceName: "end_tour")
        
        let navGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(navGesture)
        
        let conViewGesture = UITapGestureRecognizer(target: self, action: #selector(clickConView))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(conViewGesture)
    }
    
    @IBAction func didTapEndTour(_ sender: Any) {
        dismiss(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("endTour"), object: nil)
    }

}
