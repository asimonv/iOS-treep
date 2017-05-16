//
//  PostComposerViewController.swift
//  treep
//
//  Created by Andre Simon on 12/15/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit

class PostComposerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dismissViewButton: UIButton!
    @IBOutlet weak var teacherImageView: UIImageView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var commentTextView: PlaceholderTextView!
    
    var teacher: Teacher!
    var settings = Settings()
    var service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //NotificationCenter.default.addObserver(self, selector: #selector(PostComposerViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(PostComposerViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.commentTextView.delegate = self
        
        self.teacherImageView.layer.borderWidth = 3
        self.teacherImageView.layer.borderColor = UIColor.white.cgColor
        
        self.teacherImageView.layer.cornerRadius = self.teacherImageView.frame.width / 2
        self.teacherImageView.clipsToBounds = true
        
        self.teacherImageView.kf.setImage(with: URL(string: self.teacher.imageURL),
                                                      placeholder: nil,
                                                      options: [.transition(.fade(1))],
                                                      progressBlock: nil,
                                                      completionHandler: nil)


    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.sendCommentButton.isEnabled = true
        }
        
        else{
            self.sendCommentButton.isEnabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        print("dismiss")
        commentTextView.endEditing(true)
        
        dismiss(animated: true, completion: nil)

        
    }
    
    @IBAction func sendComment(_ sender: Any) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let parameters = ["t_id": self.teacher.id, "user_key": appDelegate.userKey, "text": self.commentTextView.text!] as [String : Any]
        
        
        self.service.submitAction(url: self.settings.commentTeacher, parameters: parameters, callback: { response in
                print(response)
            
                DispatchQueue.main.async{
                    self.commentTextView.resignFirstResponder()
                }
            
                self.dismiss(animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        
                        let notification = CWStatusBarNotification()
                        notification.backgroundColor = self.settings.notificationColor
                        notification.animationInStyle = self.settings.animationInStyle
                        notification.animationOutStyle = self.settings.animationOutStyle
                        notification.style = self.settings.notificationStyle
                        notification.notificationLabel?.font = self.settings.notificationFont
                        notification.displayNotification(message: self.settings.thanksForComment, duration: 2)
                        
                        let comment = TeacherComment(teacherID: self.teacher.id, text: self.commentTextView.text!, userKey: appDelegate.userKey)
                        
                        NotificationCenter.default.post(name: Notification.Name("CommentSent"), object: ["comment": comment])
                        
                    })
                })
            

        })
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
