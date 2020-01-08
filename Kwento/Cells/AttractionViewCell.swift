//
//  AttractionViewCell.swift
//  Kwento
//
//  Created by Art John on 21/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit

class AttractionViewCell : UITableViewCell {
    var  imageData : UIImage?
    var titleData : String?
    var attractionData : String?
    
    var background: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "default_image")
        return image
    }()
    
    var transView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        return view
    }()
    
    var icon: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "ic_pin_location")
        return image
    }()
    
    var title: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "SAMPLE TITLE"
        text.textColor = .white
        text.font = UIFont(name: text.font.fontName, size: 22)
        return text
    }()
    
    var attraction: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .black
        text.textColor = .white
        text.text = "SAMPLE ATTRACTION"
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(background)
        background.addSubview(transView)
        background.addSubview(icon)
        background.addSubview(title)
        background.addSubview(attraction)
        
        
        background.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        background.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        background.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        background.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
       
        
        transView.frame = CGRect(x: 0, y: 0, width: 500, height:  150.0)
        
        
        
        attraction.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        attraction.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 20).isActive = true
        attraction.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        icon.bottomAnchor.constraint(equalTo: attraction.topAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: title.topAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 12).isActive = true

        title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
        title.bottomAnchor.constraint(equalTo: attraction.topAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let backgroundImage = imageData  {
            self.background.image = backgroundImage
        }
        if let title = titleData {
            self.title.text = title
        }
        if let attraction = attractionData {
            self.attraction.text = attraction
        }
    }
    //sample
}
