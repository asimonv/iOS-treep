//
//  CourseViewCell.swift
//  treep
//
//  Created by Andre Simon on 12/19/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class CourseViewCell: UICollectionViewCell {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var endorseButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var courseNumberLabel: UILabel!
    @IBOutlet weak var bestCourseLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    var isEndorsed: Bool = false
    var isAdded = false
    
    
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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 7
        
        /*self.endorseButton.layer.borderColor = UIColor.white.cgColor
        self.endorseButton.layer.borderWidth = 1
        self.endorseButton.layer.cornerRadius = 7*/
        self.bestCourseLabel.layer.cornerRadius = 3
        
    }

    @IBAction func endorseButtonPressed(_ sender: Any) {
        
        let collectionView = self.superview as! UICollectionView
        
        let index = collectionView.indexPath(for: self)?.row
        
        let relatedCourseEndorseNotificationName = Notification.Name("RelatedCourseEndorseButtonTouched")
        NotificationCenter.default.post(name: relatedCourseEndorseNotificationName, object: ["index": index!, "button": self.endorseButton])
        
        self.isEndorsed = self.isEndorsed ? false: true
        
    }
    
    @IBAction func addCourseButtonPressed(_ sender: Any) {
        
        let collectionView = self.superview as! UICollectionView
        
        let index = collectionView.indexPath(for: self)?.row
        
        let relatedCourseEndorseNotificationName = Notification.Name("RelatedCourseAddButtonTouched")
        NotificationCenter.default.post(name: relatedCourseEndorseNotificationName, object: ["index": index!, "button": self.addButton])
        
        self.isAdded = self.isAdded ? false: true
        
    }
    
    
    
}
