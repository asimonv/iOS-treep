//
//  SearchCell.swift
//  treep
//
//  Created by Andre Simon on 4/27/17.
//  Copyright © 2017 Andre Simon. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
    
        let tableView = self.superview?.superview as! UITableView
        
        let index = tableView.indexPath(for: self)?.row
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleUserCourseIndex"), object: index)
        
    }
    
}
