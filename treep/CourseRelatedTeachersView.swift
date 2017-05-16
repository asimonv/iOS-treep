//
//  CourseRelatedTeachersView.swift
//  treep
//
//  Created by Andre Simon on 12/20/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class CourseRelatedTeachersView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWrapper: UIView!
    @IBOutlet weak var wrapperMessageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> CourseRelatedTeachersView {
        let view = UINib(nibName: "CourseRelatedTeachersView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CourseRelatedTeachersView
        view.layer.cornerRadius = 7
        
        return view
    }

}
