//
//  UIView+Extensions.swift
//  Kwento
//
//  Created by Richtone Hangad on 23/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setVisibility(_ boolean: Bool) {
        isHidden = !boolean
    }
    
    func addWave() {
        
        let view = UIView(frame: CGRect(x: frame.size.width / 4, y: frame.size.height - 100, width: frame.size.width, height: 100))
        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0.0, y: 200))
//        path.addCurve(to: CGPoint(x: frame.size.width, y: 150),
//                      controlPoint1: CGPoint(x: frame.size.width * 0.35, y: 100),
//                      controlPoint2: CGPoint(x:frame.size.width * 0.55, y: frame.size.height * 1.25))
//        path.addLine(to: CGPoint(x: view.frame.size.width, y: view.frame.size.height))
//        path.addLine(to: CGPoint(x: 0.0, y: view.frame.size.height))
//        path.close()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 200))
        path.addCurve(to: CGPoint(x: frame.size.width, y: 150),
                      controlPoint1: CGPoint(x: frame.size.width * 0.35, y: 100),
                      controlPoint2: CGPoint(x:frame.size.width * 0.55, y: frame.size.height * 1.25))
        path.addLine(to: CGPoint(x: view.frame.size.width, y: view.frame.size.height))
        path.addLine(to: CGPoint(x: 0.0, y: view.frame.size.height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        view.backgroundColor = .black
        view.layer.mask = shapeLayer
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        print(self.frame)
//        self.bringSubviewToFront(view)
    }
    
}
