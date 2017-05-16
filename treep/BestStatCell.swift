//
//  BestStatCell.swift
//  treep
//
//  Created by Andre Simon on 12/31/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class BestStatCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statTarget: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
