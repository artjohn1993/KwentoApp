//
//  CheckEmailController.swift
//  Kwento
//
//  Created by Art John on 30/01/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//

import UIKit

class CheckEmailController: UIViewController {

    @IBOutlet var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       initView()
    }
    
    @objc
    func checkEmail(sender:UITapGestureRecognizer) {
        print("doneChecking")
        self.performSegue(withIdentifier: "doneChecking", sender: nil)
    }
    
    func initView() {
        logo.image = #imageLiteral(resourceName: "img_download_complete")
        
        let navGesture = UITapGestureRecognizer(target: self, action: #selector(checkEmail))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(navGesture)
    }
}
