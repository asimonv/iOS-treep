//
//  RelatedTeacherCell.swift
//  treep
//
//  Created by Andre Simon on 12/20/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class RelatedTeacherCell: UICollectionViewCell {

    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var teacherFirstNameLabel: UILabel!
    @IBOutlet weak var teacherLastNameLabel: UILabel!
    @IBOutlet weak var teacherRankWrapperView: UIView!
    @IBOutlet weak var bestTeacherLabel: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
}
