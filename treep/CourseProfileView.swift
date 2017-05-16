//
//  CourseProfileView.swift
//  treep
//
//  Created by Andre Simon on 12/19/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class CourseProfileView: UIView {

    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    
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

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> CourseProfileView {
        let view = UINib(nibName: "CourseProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CourseProfileView
        view.layer.cornerRadius = 7
        
        return view
    }
    
    

}
