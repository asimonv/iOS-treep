//
//  HomeStatsView.swift
//  treep
//
//  Created by Andre Simon on 12/21/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class HomeStatsView: UIView {

    @IBOutlet weak var teacherTimestampLabel: UILabel!
    @IBOutlet weak var coursesTimestampLabel: UILabel!
    @IBOutlet weak var totalTeacherVotesLabel: UILabel!
    @IBOutlet weak var totalCoursesVotesLabel: UILabel!
    @IBOutlet weak var totalTeacherVotesWrapperView: StatView!
    @IBOutlet weak var totalCoursesVotesWrapperView: StatView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> HomeStatsView {
        let view = UINib(nibName: "HomeStatsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HomeStatsView
        
        return view
    }

}
