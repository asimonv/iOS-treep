//
//  TeacherCoursesView.swift
//  treep
//
//  Created by Andre Simon on 12/18/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class TeacherCoursesView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> TeacherCoursesView {
        let view = UINib(nibName: "TeacherCoursesView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TeacherCoursesView
        
        return view
    }

}
