//
//  DetailedTeacherViewController.swift
//  treep
//
//  Created by Andre Simon on 12/13/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit
import ScrollableGraphView
import SCLAlertView
import Alamofire
import Kingfisher
import CoreData

class DetailedTeacherViewController:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var teacher: Teacher!
    var statsView: TeacherStatsView!
    //var graphView: TeacherGraphView!
    var profileView: TeacherProfileView!
    var commentsView: TeacherCommentsView!
    var coursesView: TeacherCoursesView!
    var noCommentsTapGestureRecognizer: UITapGestureRecognizer!
    var profileViewGestureRecognizer: UITapGestureRecognizer!

    var teacherCourses = [Course]()
    var userCourses = [CourseData]()
    
    var teacherComments = [TeacherComment]()
    var endorsedCourses = [EndorsedCourse]()
    var teacherVotes = [Vote]()
    
    var settings = Settings()
    var service = Service()
    var isListening: Bool!
    
    let transparentPixel = UIImage.imageWithColor(color: UIColor.clear)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

   
    @IBOutlet weak var composeMessageButton: UIBarButtonItem!
    @IBOutlet weak var graphWrapperView: UIView!
    @IBOutlet weak var statsWrapperView: UIView!
    @IBOutlet weak var commentsWrapperView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coursesWrapperView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Profile"
        
        self.userCourses = Utilities.getSavedCoursesEntities() as! [CourseData]
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        self.statsView = TeacherStatsView.instanceFromNib()
        //self.graphView = TeacherGraphView.instanceFromNib()
        self.profileView = TeacherProfileView.instanceFromNib()
        self.commentsView = TeacherCommentsView.instanceFromNib()
        self.coursesView = TeacherCoursesView.instanceFromNib()
        
        self.navigationItem.titleView = self.profileView
    
        //self.graphWrapperView.addSubview(self.graphView)
        self.statsWrapperView.addSubview(self.statsView)
        self.commentsWrapperView.addSubview(self.commentsView)
        self.coursesWrapperView.addSubview(self.coursesView)
        
        self.coursesWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        self.commentsWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        self.coursesView.collectionView.layer.cornerRadius = self.settings.viewCornerRadius
        self.commentsView.layer.cornerRadius = self.settings.viewCornerRadius
        self.commentsView.collectionView.layer.cornerRadius = self.settings.viewCornerRadius
        
        /*let graphViewFrame = CGRect(x: 0, y: 0, width: self.graphWrapperView.frame.width, height: self.graphWrapperView.frame.height)
        let graphView = ScrollableGraphView(frame: graphViewFrame)
        let data: [Double] = [4, 8, 15, 16, 23, 42, 43, 44, 45, 50, 49, 48]
        let labels = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
        graphView.set(data: data, withLabels: labels)
        
        graphView.bottomMargin = 20
        graphView.topMargin = 20
        
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#F9690E")
        graphView.lineColor = UIColor.clear
        graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        graphView.shouldFill = true
        graphView.fillColor = UIColor.colorFromHex(hexString: "#FFE9FF").withAlphaComponent(0.3)
        
        graphView.shouldDrawDataPoint = false
        graphView.dataPointSpacing = 80
        graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.dataPointLabelColor = UIColor.white
        
        graphView.referenceLineThickness = 1
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.referenceLineColor = UIColor.white
        graphView.referenceLineLabelColor = UIColor.white
        
        graphView.numberOfIntermediateReferenceLines = 0
        graphView.shouldAnimateOnStartup = true
        
        graphView.rangeMax = 50
        graphView.layer.cornerRadius = 7
        
        
        self.graphView.addSubview(graphView)
        self.graphWrapperView.layer.cornerRadius = 7*/
        
        self.profileView.teacherNameLabel.text = self.teacher.name
        
        statsViewSetting()
        updateTeacherStats()
        relatedCoursesViewSetting()
        
        /*let selector = #selector(commentsWrapperViewTapped(_:))
        
        self.noCommentsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        self.commentsWrapperView.addGestureRecognizer(self.noCommentsTapGestureRecognizer)*/
        
        let selector = #selector(profileViewTapped(_:))
         
        self.profileViewGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        self.profileView.addGestureRecognizer(self.profileViewGestureRecognizer)
        
        self.profileView.addGestureRecognizer(profileViewGestureRecognizer)
        
        self.commentsView.collectionView.delegate = self
        self.commentsView.collectionView.dataSource = self
        self.commentsView.collectionView.register(UINib(nibName: "CommentViewCell", bundle: nil), forCellWithReuseIdentifier: "CommentViewCell")
        self.commentsView.noCommentsView.isHidden = false
        
        self.coursesView.collectionView.delegate = self
        self.coursesView.collectionView.dataSource = self
        self.coursesView.collectionView.register(UINib(nibName: "CourseViewCell", bundle: nil), forCellWithReuseIdentifier: "TeacherCourseCell")
        
        self.scrollView.canCancelContentTouches = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.statsView.addGestureRecognizer(tapGestureRecognizer)
        
        let commentNotificationName = Notification.Name("CommentSent")
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedTeacherViewController.recieveComment), name: commentNotificationName, object: nil)
        
        let addCourseNotificationName = Notification.Name("RelatedCourseAddButtonTouched")
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedTeacherViewController.addButtonTouched(notification:)), name: addCourseNotificationName, object: nil)
        
        print(teacher)
        
        var parameters: Parameters = ["t_id": self.teacher.id]
        //get teacher info
        Alamofire.request(settings.getTeacher, parameters: parameters)
            .responseJSON { response in
                
                if let json = response.result.value as? [String: Any]{
                    
                    if let url = json["img_url"] as? String{
                        
                        self.profileView.teacherImageView.kf.setImage(with: URL(string: url),
                                                                      placeholder: nil,
                                                                      options: [.transition(.fade(1))],
                                                                      progressBlock: nil,
                                                                      completionHandler: nil)
                        
                    }
                    
                }
        }
        
        parameters = ["name": self.teacher.name]
        //get teacher courses
        Alamofire.request(settings.getTeacherCourses, parameters: parameters)
            .responseJSON { response in
                
                if let json = response.result.value as? [String: Any]{
                    print(json)
                    
                    let teacher_courses = json["teacher_courses"] as! NSArray
                    
                    for course in teacher_courses{
                        
                        let course_data = course as! [String: Any]
                        
                        let course = Utilities.readCourse(course_data: course_data)
                        
                        self.teacherCourses.append(course)

                    }
                    
                    parameters = ["user_key": self.appDelegate.userKey, "t_id": self.teacher.id]
                
                    Alamofire.request(self.settings.getTeacherEndorses, parameters:parameters)
                        .responseJSON(completionHandler: { response in
                            
                            print(response)
                            
                            if let json = response.result.value as? [String: Any]{
                                print(json)
                                
                                let endorsedCourses = json["endorses"] as! NSArray
                                
                                for endorsedCourse in endorsedCourses{
                                    
                                    let course_data = endorsedCourse as! [String: Any]
                                    
                                    let sigla = course_data["sigla"] as! String
                                    let endorsed = (course_data["endorsed"] as! NSString).intValue
                                    let endorses = (course_data["endorses"] as! NSString).intValue

                                    
                                    for i in self.teacherCourses.indices{
                                        
                                        if self.teacherCourses[i].sigla == sigla{
                                            self.teacherCourses[i].isEndorsed = Bool(endorsed as NSNumber)
                                            self.teacherCourses[i].endorses = endorses
                                        }
                                        
                                    }
                                }
                            
                            }
                            
                            
                            self.coursesView.collectionView.reloadData()
                    
                    })
                }
        }
        
        //get teacher comments
        parameters = ["t_id": self.teacher.id]
        Alamofire.request(settings.getTeacherComments, parameters: parameters)
            .responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [String: Any]{
                    
                    let comments = json["comments"] as! NSArray
                    
                    for comment in comments{
                        
                        let comment_data = comment as! [String: Any]
                        let comment = self.readTeacherComment(comment_data: comment_data)
                        
                        self.teacherComments.append(comment)
                    }
                    
                }
                
                if self.teacherComments.count > 0{
                    self.commentsView.collectionView.reloadData()
                    self.commentsView.noCommentsView.isHidden = true
                }
                
                else{
                    
                    let selector = #selector(self.commentsWrapperViewTapped(_:))
                     
                    self.noCommentsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
                    self.commentsWrapperView.addGestureRecognizer(self.noCommentsTapGestureRecognizer)
                    self.commentsView.noCommentsView.layer.cornerRadius = self.settings.viewCornerRadius
                    
                }
                
            })
        
        //get teacher votes
        /*parameters = ["t_id": self.teacher.id]
        Alamofire.request(settings.getTeacherVotes, parameters: parameters)
            .responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [String: Any]{
                    
                    print(json)
                    
                    let votes = json["votes"] as! NSArray
                    
                    for vote in votes{
                        
                        let vote_data = vote as! [String: Any]
                        let vote = self.readTeacherVotes(vote_data: vote_data)
                        
                        self.teacherVotes.append(vote)
                    }
                    
                    self.updateTeacherStats()
                    
                }
                
            
            })*/
        
        
    }
    
    // MARK: - Gestures
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleTap(tap: UITapGestureRecognizer)  {
        
        let view = tap.view
        let loc = tap.location(in: view)
        
        if let subview = view?.hitTest(loc, with: nil) as? StatView{
            
            subview.tapped()
            
        }
        
    }
    
    func profileViewTapped(_ sender: UITapGestureRecognizer){
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "DeepTeacherViewController") as! DeepTeacherViewController
        
        popup.teacherImage = self.profileView.teacherImageView.image
        
        self.navigationController?.pushViewController(popup, animated: true)
    }
    
    func commentsWrapperViewTapped(_ sender: UITapGestureRecognizer){
        
        print("commentsWrapperViewTapped")
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "PostComposerViewController") as! PostComposerViewController
        popup.teacher = self.teacher
        //let navigationController = UINavigationController(rootViewController: popup!)
        //navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func relatedCoursesViewSetting(){
        let relatedCourseEndorseNotificationName = Notification.Name("RelatedCourseEndorseButtonTouched")
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedTeacherViewController.endorseButtonTouched), name: relatedCourseEndorseNotificationName, object: nil)
    }
    
    func statsViewSetting(){
        
        self.statsView.clarityWrapperView.type = "clarity"
        self.statsView.knowledgeWrapperView.type = "knowledge"
        self.statsView.exigencyWrapperView.type = "exigency"
        self.statsView.dispositionWrapperView.type = "disposition"
        self.statsView.popularityWrapperView.type = "popularity"
        
        self.statsView.clarityWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        self.statsView.knowledgeWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        self.statsView.exigencyWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        self.statsView.dispositionWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        //self.statsView.factorWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        self.statsView.popularityWrapperView.layer.cornerRadius = self.settings.viewCornerRadius
        
        
        self.statsView.clarityLabel.text = "\(self.teacher.clarity)"
        self.statsView.knowledgeLabel.text = "\(self.teacher.knowledge)"
        self.statsView.exigencyLabel.text = "\(self.teacher.exigency)"
        self.statsView.dispositionLabel.text = "\(self.teacher.disposition)"
        
        let votes = ["popularity", "knowledge", "exigency", "disposition", "clarity"]
        
        for stat in votes{
            
            let voted = Int(((self.teacher.votes["user_votes"] as! [String: Any?])[stat] as! [String: String])["voted"]!)!
            
            switch stat {
            case "popularity":
                self.statsView.votedPopularityLabel.isHidden = voted == 1 ? false : true
                self.statsView.popularityWrapperView.isVoted = voted == 1 ? true : false
            
            case "knowledge":
                self.statsView.votedKnowledgeLabel.isHidden = voted == 1 ? false : true
                self.statsView.knowledgeWrapperView.isVoted = voted == 1 ? true : false
            
            case "exigency":
                self.statsView.votedExigencyLabel.isHidden = voted == 1 ? false : true
                self.statsView.exigencyWrapperView.isVoted = voted == 1 ? true : false
                
            case "disposition":
                self.statsView.votedDispositionLabel.isHidden = voted == 1 ? false : true
                self.statsView.dispositionWrapperView.isVoted = voted == 1 ? true : false
                
            case "clarity":
                self.statsView.votedClarityLabel.isHidden = voted == 1 ? false : true
                self.statsView.clarityWrapperView.isVoted = voted == 1 ? true : false
            default:
                break
            }
            
        }

    }
    
    // MARK: - View controller lifecycle
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let notificationName = Notification.Name("StatViewTouched")
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedTeacherViewController.statViewTouched), name: notificationName, object: nil)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationName = Notification.Name("StatViewTouched")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*func drawCustomNavigationBar() {
        let nav = (self.navigationController?.navigationBar)!
        nav.setBackgroundImage(transparentPixel, for: UIBarMetrics.default)
        nav.shadowImage = transparentPixel
        nav.isTranslucent = true
    }*/
    
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if collectionView.isEqual(self.commentsView.collectionView){
            return teacherComments.count
        }
        
        else{
            return teacherCourses.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.isEqual(self.commentsView.collectionView){
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentViewCell", for: indexPath) as! CommentViewCell
            
            let totalComments = teacherComments.count
            let commentIndex = indexPath.row + 1
            
            cell.postNumberLabel.text = "\(commentIndex)/\(totalComments)"
            
            cell.commentTextLabel.text = self.teacherComments[indexPath.row].text
            
            cell.commentTextLabel.sizeToFit()
            
            return cell
            
        }
        
        else{
            
            let course = self.teacherCourses[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherCourseCell", for: indexPath) as! CourseViewCell
            
            cell.courseNameLabel.text = "\(course.sigla) - \(course.name)"
            cell.difficultyLabel.text = Utilities.getDifficultyText(factor: course.factor, with: true)
            
            let totalCourses = teacherCourses.count
            let courseIndex = indexPath.row + 1
            
            cell.courseNumberLabel.text = "\(courseIndex)/\(totalCourses)"
            
            cell.courseNameLabel.sizeToFit()
            
            if course.isEndorsed{
                cell.endorseButton.setTitle(settings.unEndorseText, for: .normal)
            }
            
            if let _ = getSavedCourseEntity(course: course){
                cell.addButton.setTitle(settings.removeCourseText, for: .normal)
                cell.isAdded = true
            }
            
            else{
                cell.isAdded = false
                cell.addButton.setTitle(settings.addCourseText, for: .normal)
            }
            
            
            cell.bestCourseLabel.isHidden = indexPath.row == 0 && course.endorses > 0 ? false:true
            
            //cell.difficultyLabel.text = Utilities.getDifficultyText(factor: Utilities.calculateDifficulty(course: course))
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(#function)
        
        if collectionView.isEqual(self.commentsView.collectionView){
            
            let detailedCommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailedCommentViewController") as! DetailedCommentViewController
            //let navigationController = UINavigationController(rootViewController: popup!)
            //navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            //self.present(popup!, animated: true, completion: nil)
            
            detailedCommentViewController.comment = self.teacherComments[indexPath.row]
            
            self.navigationController?.pushViewController(detailedCommentViewController, animated: true)
        }
        
        else{
            let courseViewController = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
            courseViewController.course = self.teacherCourses[indexPath.row]
            
            self.navigationController?.pushViewController(courseViewController, animated: true)

        }
        
    }
    
    //MARK: - UICollectionViewFlowDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //UIScreen.mainScreen().bounds.width
        
        if collectionView.isEqual(self.commentsView.collectionView){
            return CGSize(width: self.commentsView.collectionView.bounds.size.width - 3, height: self.commentsView.collectionView.bounds.size.height)
        }
        
        else{
            print(self.coursesView.collectionView.bounds.size.width)
            return CGSize(width: self.coursesView.collectionView.bounds.size.width - 3, height: self.coursesView.collectionView.bounds.size.height)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    // MARK: - Reading JSON Data
    
    func readTeacherVotes(vote_data: [String: Any]) -> Vote{
        
        let value = (vote_data["stat_value"] as! NSString).intValue
        let type = (vote_data["stat"] as! NSString).intValue
        let timestamp = vote_data["timestamp"] as? Int32
        
        return Vote(value: value, type: type, timestamp: timestamp!)
        
    }
    
    /*func readEndorsedCourse(course_data: [String: Any]) -> EndorsedCourse{
        
        let sigla = course_data["sigla"] as! String
        let teacherID = (course_data["t_id"] as! NSString).intValue
        let userKey = course_data["user_key"] as! String
        let endorsed = (course_data["endorsed"] as! NSString).intValue
        let endorses = (course_data["endorses"] as! NSString).intValue
        
        return EndorsedCourse(sigla: sigla, teacherID: teacherID, userKey: userKey)
        
    }*/
    
    func readTeacherComment(comment_data: [String: Any]) -> TeacherComment{
        
        let text = comment_data["text"] as! String
        let teacherID = (comment_data["t_id"] as! NSString).intValue
        let userKey = comment_data["user_key"] as! String
        
        return TeacherComment(teacherID: teacherID, text: text, userKey: userKey)
        
    }
    
    // MARK: - Notifications
    
    func recieveComment(notification: Notification){
        
        let object = notification.object as! [String: Any]
        let comment = object["comment"] as! TeacherComment
        
        self.teacherComments.append(comment)
        
        self.commentsView.noCommentsView.isHidden = true
        
        self.commentsView.collectionView.reloadData()
        
        if self.noCommentsTapGestureRecognizer != nil{
            self.commentsWrapperView.removeGestureRecognizer(self.noCommentsTapGestureRecognizer)
        }
 
    }
    
    func statViewTouched(notification: Notification){
        
        let object = notification.object as! [String: Any]
        let type = object["type"] as! String
        
        let isVoted = object["isVoted"] as! Bool
        
        let statName = type
        
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: 0, y: 0, width: alertController.view.bounds.size.width - margin * 4.0, height: 140)
        let customView = StarView.instanceFromNib()
        customView.frame = rect
        customView.statTitleLabel.text = "Rate \(self.teacher.name)'s \(statName)"
        
        customView.backgroundColor = .clear
        alertController.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: customView, attribute: .topMargin, relatedBy: .equal, toItem: alertController.view, attribute: .topMargin, multiplier: 1, constant: margin)
        let trailingConstraint = NSLayoutConstraint(item: customView, attribute: .trailingMargin, relatedBy: .equal, toItem: alertController.view, attribute: .trailingMargin, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: customView, attribute: .leadingMargin, relatedBy: .equal, toItem: alertController.view, attribute: .leadingMargin, multiplier: 1, constant: 0)
        alertController.view.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        if type == "popularity"{
            customView.upDownView.isHidden = false
            customView.fifthButton.isHidden = true
            customView.fourthButton.isHidden = true
            customView.thirdButton.isHidden = true
            customView.secondButton.isHidden = true
            customView.firstButton.isHidden = true
        }
            
        else{
            customView.upDownView.isHidden = true
        }
        
        let somethingAction = UIAlertAction(title: "Send", style: .default, handler: {(alert: UIAlertAction!) in
            
            if customView.selectedButton != nil{
                
                var statNumber: Int!
                
                switch type{
                case "clarity":
                    statNumber = 1
                case "knowledge":
                    statNumber = 2
                case "exigency":
                    statNumber = 3
                case "disposition":
                    statNumber = 4
                case "popularity":
                    statNumber = 0
                default:
                    statNumber = -1
                }
                
                print(statNumber)
                
                var value = 0
                
                if customView.selectedButton == customView.upButton{
                    value = 1
                }
                    
                else if customView.selectedButton == customView.downButton{
                    value = -1
                }
                    
                else{
                    value = Int(customView.selectedButton.titleLabel!.text!)!
                }
                
                print(self.teacher.id)
                
                let parameters = ["action": "vote", "stat": statNumber, "t_id": self.teacher.id, "value": value, "user_key": self.appDelegate.userKey] as [String : Any]
                self.service.submitAction(url: self.settings.teacherStat, parameters: parameters, callback: { response in
                    
                    print(response)
                    
                    let vote = Vote(value: Int32(value), type: Int32(statNumber), timestamp: -1)
                    self.teacherVotes.append(vote)
                    
                    //thanks for voting message
                    DispatchQueue.main.async {
                        let notification = CWStatusBarNotification()
                        notification.backgroundColor = self.settings.notificationColor
                        notification.animationInStyle = self.settings.animationInStyle
                        notification.animationOutStyle = self.settings.animationOutStyle
                        notification.style = self.settings.notificationStyle
                        notification.notificationLabel?.font = self.settings.notificationFont
                        notification.displayNotification(message: self.settings.thanksForVotingText, duration: 2)
                        
                        self.updateTeacherStats()
                    }
                    
                    
                })
                
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        if isVoted{
            let removeAction = UIAlertAction(title: "Remove vote", style: .destructive, handler: {(alert: UIAlertAction!) in print("remove-vote")})
            alertController.addAction(removeAction)
        }
        
        self.present(alertController, animated: true, completion:{})
        
    }

    func addButtonTouched(notification: Notification){
        
        print("add button presssed")
        
        let notificationObject = notification.object as! [String: Any]
        
        let index = notificationObject["index"] as! Int
        let button = notificationObject["button"] as! UIButton
        
        let course = teacherCourses[index]
        
        let isSaved = Utilities.isCourseSaved(sigla: course.sigla)
        
        if isSaved{
            
            button.setTitle(self.settings.addCourseText, for: .normal)
            
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            if let object = getSavedCourseEntity(course: course) as? CourseData{
                
                managedContext.delete(object)
                
                if let index = self.userCourses.index(of: object){
                    
                    self.userCourses.remove(at: index)
                    
                    //4
                    do {
                        try managedContext.save()
                        
                        DispatchQueue.main.async {
                            let notification = CWStatusBarNotification()
                            notification.backgroundColor = self.settings.notificationColor
                            notification.animationInStyle = self.settings.animationInStyle
                            notification.animationOutStyle = self.settings.animationOutStyle
                            notification.style = self.settings.notificationStyle
                            notification.notificationLabel?.font = self.settings.notificationFont
                            notification.displayNotification(message: self.settings.courseRemovedText, duration: 2)
                            
                            //self.updateTeacherStats()
                        }
                        
                        
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    
                }
                
            }
            
            
        }
            
        else{
            self.saveCourseToCoreData(course.name, sigla: course.sigla)
            
            button.setTitle(self.settings.removeCourseText, for: .normal)
            
            DispatchQueue.main.async {
                let notification = CWStatusBarNotification()
                notification.backgroundColor = self.settings.notificationColor
                notification.animationInStyle = self.settings.animationInStyle
                notification.animationOutStyle = self.settings.animationOutStyle
                notification.style = self.settings.notificationStyle
                notification.notificationLabel?.font = self.settings.notificationFont
                notification.displayNotification(message: self.settings.courseAddedText, duration: 2)
                
                //self.updateTeacherStats()
            }
            
        }
        
    }

    func endorseButtonTouched(notification: Notification){
        
        print("touched")
        
        let object = notification.object as! [String: Any]
        let index = object["index"] as! Int
        let button = object["button"] as! UIButton
        
        if self.teacherCourses[index].isEndorsed{
            self.teacherCourses[index].isEndorsed = false
            self.teacherCourses[index].endorses -= 1
            button.setTitle(self.settings.endorseText, for: .normal)
        }
        
        else{
            self.teacherCourses[index].isEndorsed = true
            self.teacherCourses[index].endorses += 1
            button.setTitle(self.settings.unEndorseText, for: .normal)
        }
        
        let parameters = ["user_key": self.appDelegate.userKey!, "t_id": self.teacher.id, "sigla": self.teacherCourses[index].sigla] as [String : Any]
        self.service.submitAction(url: self.settings.endorseCourse, parameters: parameters, callback:{ response in
            
            if response["response"] == 1{
                
                DispatchQueue.main.async {
                    let notification = CWStatusBarNotification()
                    notification.backgroundColor = self.settings.notificationColor
                    notification.animationInStyle = self.settings.animationInStyle
                    notification.animationOutStyle = self.settings.animationOutStyle
                    notification.style = self.settings.notificationStyle
                    notification.notificationLabel?.font = self.settings.notificationFont
                    notification.displayNotification(message: self.settings.thanksForVotingText, duration: 2)
                }
                
            }
        })
    }
    
    // MARK - Stats
    
    func updateTeacherStats(){
        
        /*
        0: clarity
        1: knowledge
        2: exigency
        3: disposition
        4: popularity
        */
        
        print(#function)
        print(teacher.votes)
        
        let votes = teacher.votes
        let clarityVotes = Int((votes["clarity"] as! [String: String])["count"]!)!
        let knowledgeVotes = Int((votes["knowledge"] as! [String: String])["count"]!)!
        let exigencyVotes = Int((votes["exigency"] as! [String: String])["count"]!)!
        let dispositionVotes = Int((votes["disposition"] as! [String: String])["count"]!)!
        let popularityVotes = Int((votes["popularity"] as! [String: String])["count"]!)!
        
        let clarityMessage =  clarityVotes > 0 ? "\(clarityVotes) vote/s" : "no votes"
        let knowledgeMessage = knowledgeVotes > 0 ? "\(knowledgeVotes) vote/s" : "no votes"
        let exigencyMessage = exigencyVotes > 0 ? "\(exigencyVotes) vote/s" : "no votes"
        let dispositionMessage = dispositionVotes > 0 ? "\(dispositionVotes) vote/s" : "no votes"
        let popularityMessage = popularityVotes > 0 ? "\(popularityVotes) vote/s" : "no votes"
        

        let clarity: Any = clarityVotes == 0 ? "--": teacher.clarity
        let knowledge: Any = knowledgeVotes == 0 ? "--": teacher.knowledge
        let exigency: Any = exigencyVotes == 0 ? "--": teacher.exigency
        let disposition: Any = dispositionVotes == 0 ? "--": teacher.disposition
        let popularity: Any = popularityVotes == 0 ? "--": teacher.popularity
        
        self.statsView.clarityLabel.text = "\(clarity)"
        self.statsView.knowledgeLabel.text = "\(knowledge)"
        self.statsView.dispositionLabel.text = "\(disposition)"
        self.statsView.exigencyLabel.text = "\(exigency)"
        self.statsView.popularityLabel.text = "\(popularity)"
        
        self.statsView.clarityVotesLabel.text = "\(clarityMessage)"
        self.statsView.knowledgeVotesLabel.text = "\(knowledgeMessage)"
        self.statsView.dispositionVotesLabel.text = "\(dispositionMessage)"
        self.statsView.exigencyVotesLabel.text = "\(exigencyMessage)"
        self.statsView.popularityVotesLabel.text = "\(popularityMessage)"
        
    }
    
    // MARK: - Compose Message
    
    @IBAction func composeButtonTapped(_ sender: UIBarButtonItem) {
        
        
        print(#function)
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "PostComposerViewController") as! PostComposerViewController
        popup.teacher = self.teacher
        //let navigationController = UINavigationController(rootViewController: popup!)
        //navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popup, animated: true, completion: nil)
        
    }
    
    // MARK: - Core Data
    
    func saveCourseToCoreData(_ name: String, sigla: String) {
        //1
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "CourseData",
                                                 in:managedContext)
        
        let course = CourseData(entity: entity!, insertInto: managedContext)
        
        //3
        course.name = name
        course.sigla = sigla
        
        //4
        do {
            try managedContext.save()
            //5
            self.userCourses.insert(course, at: 0)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func getSavedCourseEntity(course: Course) -> Any?{
        
        for userCourse in self.userCourses{
            if userCourse.sigla == course.sigla{
                return userCourse
            }
        }
        
        return nil
        
    }
    
    
}
