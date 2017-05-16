//
//  UserCoursesView.swift
//  treep
//
//  Created by Andre Simon on 12/24/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class UserCoursesView: UIView {

    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var semesterAnalysisLabel: UILabel!
    @IBOutlet weak var noCoursesWrapperView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var noCoursesMessageLabel: UILabel!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> UserCoursesView {
        let view = UINib(nibName: "UserCoursesView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UserCoursesView
        
        return view
    }

    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ClearUserCourses"), object: nil)
    }
}
