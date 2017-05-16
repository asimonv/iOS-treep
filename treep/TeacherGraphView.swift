//
//  TeacherGraphView.swift
//  treep
//
//  Created by Andre Simon on 12/14/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class TeacherGraphView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> TeacherGraphView {
        let view = UINib(nibName: "TeacherGraphView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TeacherGraphView
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }

}
