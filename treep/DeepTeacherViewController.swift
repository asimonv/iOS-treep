//
//  DeepTeacherViewController.swift
//  treep
//
//  Created by Andre Simon on 12/19/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class DeepTeacherViewController: UIViewController {

    @IBOutlet weak var teacherImageView: UIImageView!
    var teacherImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.teacherImageView.image = teacherImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
