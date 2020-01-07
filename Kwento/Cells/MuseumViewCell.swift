//
//  MuseumViewCell.swift
//  Kwento
//
//  Created by Art John on 16/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class MuseumViewCell: UITableViewCell {

    @IBOutlet var attractionImage: UIImageView!
    @IBOutlet var attractionTitle: UILabel!
    @IBOutlet var attractionDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
