//
//  StarView.swift
//  treep
//
//  Created by Andre Simon on 12/15/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class StarView: UIView {

    @IBOutlet weak var statTitleLabel: UILabel!
    @IBOutlet weak var firstButton: RoundButton!
    @IBOutlet weak var secondButton: RoundButton!
    @IBOutlet weak var thirdButton: RoundButton!
    @IBOutlet weak var fourthButton: RoundButton!
    @IBOutlet weak var fifthButton: RoundButton!
    
    @IBOutlet weak var downButton: RoundButton!
    @IBOutlet weak var upButton: RoundButton!
    
    @IBOutlet weak var upDownView: UIView!
    
    var selectedButton: RoundButton!
    let activeColor = UIColor.red.cgColor
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> StarView {
        let view = UINib(nibName: "StarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! StarView
        return view
    }

    @IBAction func buttonPressed(_ sender: RoundButton) {
        print("button pressed")
        
        let normalColor = self.tintColor
        
        if sender.select{
            
            if sender == self.downButton{
                sender.setImage(UIImage(named: "down"), for: .normal)
                
                UIView.animate(withDuration: 0.2, animations: {
                    sender.layer.backgroundColor = UIColor.clear.cgColor
                })
                
            }
            
            else if sender == self.upButton{
                sender.setImage(UIImage(named: "up"), for: .normal)
                
                UIView.animate(withDuration: 0.2, animations: {
                    sender.layer.backgroundColor = UIColor.clear.cgColor
                })
            }
            
            else{
                let title = NSAttributedString(string: (sender.titleLabel?.text)!, attributes: [NSForegroundColorAttributeName: normalColor!])
                UIView.animate(withDuration: 0.2, animations: {
                    sender.layer.backgroundColor = UIColor.clear.cgColor
                    sender.setAttributedTitle(title, for: .normal)
                })
            }
            
            print("nothing selected")
        }
        
        else{
            
            if sender == self.downButton{
                sender.setImage(UIImage(named: "down-white"), for: .normal)
                
                UIView.animate(withDuration: 0.2, animations: {
                    sender.layer.backgroundColor = self.activeColor
                })
                
            }
                
            else if sender == self.upButton{
                sender.setImage(UIImage(named: "up-white"), for: .normal)
                
                UIView.animate(withDuration: 0.2, animations: {
                    sender.layer.backgroundColor = self.activeColor
                })
            }
            
            else{
                
                let title = NSAttributedString(string: (sender.titleLabel?.text)!, attributes: [NSForegroundColorAttributeName: UIColor.white])
                UIView.animate(withDuration: 0.2, animations: {
                    sender.layer.backgroundColor = self.activeColor
                    sender.setAttributedTitle(title, for: .normal)
                })
                
            }
            
        }

        
        if self.selectedButton != nil && self.selectedButton != sender{
            
            if self.selectedButton == self.downButton{
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectedButton.layer.backgroundColor = UIColor.clear.cgColor
                    self.selectedButton.setImage(UIImage(named: "down"), for: .normal)
                    
                })
            }
            
            else if self.selectedButton == self.upButton{
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectedButton.layer.backgroundColor = UIColor.clear.cgColor
                    self.selectedButton.setImage(UIImage(named: "up"), for: .normal)
                    
                })
                
            }
            
            else{
        
                let title = NSAttributedString(string: (self.selectedButton.titleLabel?.text)!, attributes: [NSForegroundColorAttributeName: normalColor!])
                UIView.animate(withDuration: 0.2, animations: {
                    self.selectedButton.layer.backgroundColor = UIColor.clear.cgColor
                    self.selectedButton.setAttributedTitle(title, for: .normal)
                })
            }
        
            self.selectedButton.select = self.selectedButton == sender ? true:false
            
        }
        
        self.selectedButton = sender.select == true ? nil:sender
        sender.select = sender.select == true ? false:true
        
    }

}
