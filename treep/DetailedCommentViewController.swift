//
//  DetailedCommentViewController.swift
//  treep
//
//  Created by Andre Simon on 12/16/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class DetailedCommentViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentWrapperView: UIView!
    
    var comment: TeacherComment!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Details"
        self.commentWrapperView.layer.cornerRadius = 7
        
        self.commentLabel.text = self.comment.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
