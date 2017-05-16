//
//  StatView.swift
//  treep
//
//  Created by Andre Simon on 12/15/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

@IBDesignable
class StatView: UIView {
    
    var type: String!
    var isVoted: Bool = false
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func tapped(){
        print("sending notification")
        
        let notificationName = Notification.Name("StatViewTouched")
        NotificationCenter.default.post(name: notificationName, object: ["type": type, "isVoted": isVoted])
    }
    
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor:   UIColor = .black
    
    @IBInspectable var startLocation: Double = 0.05
    @IBInspectable var endLocation:   Double = 0.95
    
    @IBInspectable var horizontalMode: Bool = false
    @IBInspectable var diagonalMode: Bool = false
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layer = layer as? CAGradientLayer else { return }
        if horizontalMode {
            if diagonalMode {
                layer.startPoint = CGPoint(x: 1, y: 0)
                layer.endPoint   = CGPoint(x: 0, y: 1)
            } else {
                layer.startPoint = CGPoint(x: 0, y: 0.5)
                layer.endPoint   = CGPoint(x: 1, y: 0.5)
            }
        } else {
            if diagonalMode {
                layer.startPoint = CGPoint(x: 0, y: 0)
                layer.endPoint   = CGPoint(x: 1, y: 1)
            } else {
                layer.startPoint = CGPoint(x: 0.5, y: 0)
                layer.endPoint   = CGPoint(x: 0.5, y: 1)
            }
        }
        layer.locations = [startLocation as NSNumber, endLocation as NSNumber]
        layer.colors    = [startColor.cgColor, endColor.cgColor]
    }

}
