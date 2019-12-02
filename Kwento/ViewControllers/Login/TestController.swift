//
//  TestController.swift
//  Kwento
//
//  Created by Richtone Hangad on 28/08/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    let width = UIScreen.main.bounds.size.width

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = UIView(frame: CGRect(x: 0, y: 100, width: 200, height: 300))
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 200))
        path.addCurve(to: CGPoint(x: 200, y:150),
                      controlPoint1: CGPoint(x: 50, y: 350),
                      controlPoint2: CGPoint(x:150, y: 0))
        path.addLine(to: CGPoint(x: view.frame.size.width, y: view.frame.size.height))
        path.addLine(to: CGPoint(x: 0.0, y: view.frame.size.height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        view.backgroundColor = UIColor.black
        view.layer.mask = shapeLayer
        self.view.addSubview(view)
    }

}
