//
//  UserCourseCell.swift
//  treep
//
//  Created by Andre Simon on 12/24/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class UserCourseCell: UICollectionViewCell {

    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var removeCourseButton: UIButton!
    @IBOutlet weak var teacherNameButton: UIButton!
    @IBOutlet weak var bestLabel: UILabel!
    
    
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
        self.bestLabel.layer.cornerRadius = 3
    }
    
    //MARK: - Actions
    
    @IBAction func removeUserCourseButtonPressed(_ sender: Any) {
        
        let collectionView = self.superview as! UICollectionView
        let indexPath = collectionView.indexPath(for: self)
        
        let notificationName = Notification.Name("removeUserCourseButtonPressed")

        NotificationCenter.default.post(name: notificationName, object: ["indexPath": indexPath])
        
    }
    
    @IBAction func teacherButtonPressed(_ sender: UIButton) {
        print(sender)
        
        let collectionView = self.superview as! UICollectionView
        let indexPath = collectionView.indexPath(for: self)
        
        let notificationName = Notification.Name("TeacherButtonPressed")
        
        NotificationCenter.default.post(name: notificationName, object: ["indexPath": indexPath])

    }
    
    

}
