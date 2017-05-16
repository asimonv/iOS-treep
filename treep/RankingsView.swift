//
//  RankingsView.swift
//  treep
//
//  Created by Andre Simon on 12/20/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class RankingsView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> RankingsView {
        let view = UINib(nibName: "RankingsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RankingsView
        view.layer.cornerRadius = 7
        
        return view
    }

}
