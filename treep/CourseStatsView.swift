//
//  CourseStatsView.swift
//  treep
//
//  Created by Andre Simon on 12/19/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class CourseStatsView: UIView {
    
    @IBOutlet weak var votedPopularityLabel: UILabel!
    @IBOutlet weak var votedDifficultyLabel: UILabel!
    @IBOutlet weak var votedWorkloadLabel: UILabel!
    @IBOutlet weak var votedInterestingLabel: UILabel!
    
    @IBOutlet weak var popularityNumberLabel: UILabel!
    @IBOutlet weak var difficultyVotesLabel: UILabel!
    @IBOutlet weak var workloadVotesLabel: UILabel!
    @IBOutlet weak var interestingVotesLabel: UILabel!
    
    @IBOutlet weak var popularityVotesLabel: UILabel!
    @IBOutlet weak var difficultyMessageLabel: UILabel!
    @IBOutlet weak var workloadMessageLabel: UILabel!
    @IBOutlet weak var interestingMessageLabel: UILabel!
    
    @IBOutlet weak var popularityWrapperView: StatView!
    @IBOutlet weak var difficultyWrapperView: StatView!
    @IBOutlet weak var workloadWrapperView: StatView!
    @IBOutlet weak var interestingWrapperView: StatView!
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> CourseStatsView {
        let view = UINib(nibName: "CourseStatsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CourseStatsView
        view.layer.cornerRadius = 5
        
        return view
    }

    @IBAction func seeMorePressed(_ sender: Any) {
        
        let notificationName = Notification.Name("SeeMoreButtonPressed")
        NotificationCenter.default.post(name: notificationName, object: nil)
        
    }
}
