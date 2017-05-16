//
//  RoundButton.swift
//  treep
//
//  Created by Andre Simon on 12/16/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    var select = false
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 0
        //self.layer.borderColor = UIColor.white.cgColor
        
    }
    
    /*override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.select{
            
            UIView.animate(withDuration: 0.2, animations: {
                //self.layer.borderColor = UIColor.white.cgColor
                self.layer.backgroundColor = UIColor.white.cgColor
                self.setTitleColor(.white, for: .normal)
                self.setTitleColor(.blue, for: .highlighted)
            })
            
        }
        
        else{
            
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.backgroundColor = UIColor.blue.cgColor
                self.setTitleColor(.blue, for: .normal)
                self.setTitleColor(.white, for: .highlighted)
            })
            
        }
        
        self.select = self.select ? false: true
    }*/

}
