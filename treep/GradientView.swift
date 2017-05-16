//
//  GradientView.swift
//  treep
//
//  Created by Andre Simon on 1/3/17.
//  Copyright © 2017 Andre Simon. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

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
        
        self.layer.cornerRadius = 5
    }

}
