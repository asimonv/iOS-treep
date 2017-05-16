//
//  TeacherProfileView.swift
//  treep
//
//  Created by Andre Simon on 12/14/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class TeacherProfileView: UIView {

    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.teacherImageView.layer.borderWidth = 3
        self.teacherImageView.layer.borderColor = UIColor.white.cgColor
         
        self.teacherImageView.layer.cornerRadius = self.teacherImageView.frame.width / 2
        self.teacherImageView.clipsToBounds = true
    }
 
    
    class func instanceFromNib() -> TeacherProfileView {
        return UINib(nibName: "TeacherProfileView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TeacherProfileView
    }

}
