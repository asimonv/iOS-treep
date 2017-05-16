//
//  TeacherCommentsView.swift
//  treep
//
//  Created by Andre Simon on 12/15/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class TeacherCommentsView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noCommentsView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> TeacherCommentsView {
        let view = UINib(nibName: "TeacherCommentsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TeacherCommentsView
        view.layer.cornerRadius = 7
        
        return view
    }

}
