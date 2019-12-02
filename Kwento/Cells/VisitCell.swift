//
//  VisitCell.swift
//  Kwento
//
//  Created by Richtone Hangad on 10/10/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit
import MaterialComponents

class VisitCell: UITableViewCell {
    
    @IBOutlet weak var attractionNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var reviewButton: MDCFlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewButton.initialize(backgroundColor: .main, titleColor: .white, cornerRadius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
