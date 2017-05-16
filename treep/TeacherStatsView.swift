//
//  TeacherStatsView.swift
//  treep
//
//  Created by Andre Simon on 12/14/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class TeacherStatsView: UIView {

    @IBOutlet weak var clarityWrapperView: StatView!
    @IBOutlet weak var knowledgeWrapperView: StatView!
    @IBOutlet weak var exigencyWrapperView: StatView!
    @IBOutlet weak var dispositionWrapperView: StatView!
    @IBOutlet weak var popularityWrapperView: StatView!
    @IBOutlet weak var factorWrapperView: StatView!
   
    @IBOutlet weak var clarityLabel: UILabel!
    @IBOutlet weak var knowledgeLabel: UILabel!
    @IBOutlet weak var exigencyLabel: UILabel!
    @IBOutlet weak var dispositionLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var factorLabel: UILabel!
    
    @IBOutlet weak var clarityVotesLabel: UILabel!
    @IBOutlet weak var knowledgeVotesLabel: UILabel!
    @IBOutlet weak var factorVotesLabel: UILabel!
    @IBOutlet weak var dispositionVotesLabel: UILabel!
    @IBOutlet weak var exigencyVotesLabel: UILabel!
    @IBOutlet weak var popularityVotesLabel: UILabel!
    
    @IBOutlet weak var votedPopularityLabel: UILabel!
    
    @IBOutlet weak var votedClarityLabel: UILabel!
    @IBOutlet weak var votedKnowledgeLabel: UILabel!
    @IBOutlet weak var votedExigencyLabel: UILabel!
    @IBOutlet weak var votedDispositionLabel: UILabel!
    
    
    
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
        
        let notificationName = Notification.Name("TeacherStatViewTouched")
        NotificationCenter.default.post(name: notificationName, object: ["type": type, "isVoted": isVoted])
    }
    
    class func instanceFromNib() -> TeacherStatsView {
        let view = UINib(nibName: "TeacherStatsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TeacherStatsView
        view.layer.cornerRadius = 7
        
        return view
    }

}
