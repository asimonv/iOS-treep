//
//  CourseViewController.swift
//  treep
//
//  Created by Andre Simon on 12/19/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreData

class CourseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    @IBOutlet weak var courseRelatedTeachersViewWrapper: UIView!
    @IBOutlet weak var courseStatsWrapper: UIView!
    @IBOutlet weak var courseProfileViewWrapper: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toggleCourseButton: UIBarButtonItem!
    
    var courseProfileView: CourseProfileView!
    var courseStatsView: CourseStatsView!
    var courseRelatedTeachersView: CourseRelatedTeachersView!
    
    var course: Course!
    var settings = Settings()
    var teachers = [Teacher]()
    var userCourses = [CourseData]()
    var service = Service()
    var activeVotedLabel: UILabel!
    
    var votedEasy: Bool!
    var votedNormal: Bool!
    var votedHard: Bool!
    var votedImpossible: Bool!
    var votedPopularity: Bool!
    var userVotes = [String: [String: Any]]()
    
    var statsTimestamps = [String: Any]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        let notificationName = Notification.Name("StatViewTouched")
        NotificationCenter.default.addObserver(self, selector: #selector(CourseViewController.statViewTouched), name: notificationName, object: nil)
        
        self.userCourses = Utilities.getSavedCoursesEntities() as! [CourseData]
        self.checkIfCourseIsSaved()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let notificationName = Notification.Name("StatViewTouched")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.courseProfileView = CourseProfileView.instanceFromNib()
        self.courseStatsView = CourseStatsView.instanceFromNib()
        self.courseRelatedTeachersView =  CourseRelatedTeachersView.instanceFromNib()
        
        self.courseProfileViewWrapper.addSubview(self.courseProfileView)
        self.courseStatsWrapper.addSubview(self.courseStatsView)
        self.courseRelatedTeachersViewWrapper.addSubview(self.courseRelatedTeachersView)
        
        self.scrollView.canCancelContentTouches = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.courseStatsView.addGestureRecognizer(tapGestureRecognizer)
        
        self.statsViewSetting()
        setFieldsCount()
        
        self.navigationItem.title = "Course"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        self.courseProfileView.courseNameLabel.text = "\(self.course.sigla) - \(self.course.name)"
        
        self.courseRelatedTeachersView.collectionView.delegate = self
        self.courseRelatedTeachersView.collectionView.dataSource = self
        
        self.courseRelatedTeachersView.collectionView.register(UINib(nibName: "RelatedTeacherCell", bundle: nil), forCellWithReuseIdentifier: "RelatedTeacherCell")
        
        let statNotificationName = Notification.Name("SeeMoreButtonPressed")
        NotificationCenter.default.addObserver(self, selector: #selector(CourseViewController.recievedDetailedStats), name: statNotificationName, object: nil)
        
        self.updateCourseStatsLabels()
        
        var parameters: Parameters = ["sigla": self.course.sigla]
        Alamofire.request(settings.getTeachersRelated, parameters: parameters)
            .responseJSON { response in
                
                if let json = response.result.value as? [String: Any]{
                    
                    print(json)
                    
                    let teachers = json["teachers"] as! NSArray
                    
                    print(teachers)
                    
                    for teacher in teachers{
                        
                        let teacher_data = teacher as! [String: Any]
                        
                        if (teacher_data["name"] as? String) != nil{
                            let _teacher = Utilities.readTeacher(teacher_data: teacher_data)
                            
                            self.teachers.append(_teacher)
                        }
                        
                    }
                    
                }
                
                if self.teachers.count > 0{
                    UIView.animate(withDuration: 0.3, animations: {
                        self.courseRelatedTeachersView.collectionViewWrapper.alpha = 0
                        self.courseRelatedTeachersView.activityIndicator.isHidden = true
                        self.courseRelatedTeachersView.activityIndicator.stopAnimating()
                    }, completion: { Bool in
                        self.courseRelatedTeachersView.collectionView.reloadData()
                        
                    })
                }
                
                else{
                    self.courseRelatedTeachersView.activityIndicator.stopAnimating()
                    self.courseRelatedTeachersView.wrapperMessageLabel.text = "Sorry. No teachers found for this course."
                    self.courseRelatedTeachersView.activityIndicator.isHidden = true
                }
                
                
                    
            }
        parameters = ["sigla": self.course.sigla, "user_key": self.appDelegate.userKey]
        
        Alamofire.request(settings.getCourseVotes, parameters: parameters)
            .responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [String: Any]{
                    print(json)
                    
                    
                    self.userVotes = json["votes"] as! [String : [String : Any]]
                    
                    self.updateStatsData()
                    
                    //let course_data = json["course_data"] as! [String: Any]
                    
                    /*self.course.easy = (course_data["easy"] as! NSString).intValue
                    self.course.normal = (course_data["normal"] as! NSString).intValue
                    self.course.hard = (course_data["hard"] as! NSString).intValue
                    self.course.impossible = (course_data["impossible"] as! NSString).intValue
                    self.course.popularity = (course_data["popularity"] as! NSString).intValue
                    
                    self.votedEasy = Bool((course_data["voted_easy"] as! NSString).intValue as NSNumber)
                    self.votedNormal = Bool((course_data["voted_normal"] as! NSString).intValue as NSNumber)
                    self.votedHard = Bool((course_data["voted_hard"] as! NSString).intValue as NSNumber)
                    self.votedImpossible = Bool((course_data["voted_impossible"] as! NSString).intValue as NSNumber)
                    self.votedPopularity = Bool((course_data["voted_popularity"] as! NSString).intValue as NSNumber)
                    
                    self.statsTimestamps = (course_data["stats"] as! NSArray) as! [[String : Any]]
                    
                    self.updateStatsTimestamps()
                    self.updateCourseVotes()
                    self.updateVotedLabels()
                    
                    self.courseProfileView.difficultyLabel.text = Utilities.getDifficultyText(factor: Utilities.calculateDifficulty(course: self.course))
                    */
                    
                }
                
            })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFieldsCount(){
        //self.courseStatsView.difficultyVotesLabel.text = "\((self.course.votes["difficulty"] as! [String: String])["count"])"
    }
    
    func statsViewSetting(){
        
        self.courseStatsView.popularityWrapperView.type = "popularity"
        self.courseStatsView.difficultyWrapperView.type = "difficulty"
        self.courseStatsView.workloadWrapperView.type = "workload"
        self.courseStatsView.interestingWrapperView.type = "interesting"
        
        self.courseStatsView.popularityWrapperView.layer.cornerRadius = 5
        self.courseStatsView.difficultyWrapperView.layer.cornerRadius = 5
        self.courseStatsView.workloadWrapperView.layer.cornerRadius = 5
        self.courseStatsView.interestingWrapperView.layer.cornerRadius = 5
        
        
        /*self.statsView.clarityLabel.text = self.teacher.votes_clarity == 0 ? "0": String(self.teacher.clarity)
        self.statsView.knowledgeLabel.text = self.teacher.votes_knowledge == 0 ? "0": String(self.teacher.knowledge)
        self.statsView.exigencyLabel.text = self.teacher.votes_exigency == 0 ? "0": String(self.teacher.exigency)
        self.statsView.dispositionLabel.text = self.teacher.votes_disposition == 0 ? "0": String(self.teacher.disposition)
        
        let notificationName = Notification.Name("CourseStatViewTouched")
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedTeacherViewController.statViewTouched), name: notificationName, object: nil)*/
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func recievedDetailedStats(notification: Notification){
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "CourseDetailedStatsViewController") as! CourseDetailedStatsViewController
        
        popup.course = self.course
        popup.navigationItem.title = "Stats Details"
        
        self.navigationController?.pushViewController(popup, animated: true)
        
    }
    
    
    // MARK: - UICollectionView 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.teachers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedTeacherCell", for: indexPath) as! RelatedTeacherCell
        
        let teacherRank = indexPath.row + 1
        cell.bestTeacherLabel.isHidden = true
        
        if teacherRank <= 3{
            
            cell.teacherRankWrapperView.isHidden = false
            
            var color: UIColor!
            
            switch teacherRank {
            case 1:
                color = UIColor.colorFromHex(hexString: "#FFD700")
                cell.bestTeacherLabel.isHidden = false
            case 2:
                color = UIColor.colorFromHex(hexString: "#BDC3C7")
            case 3:
                color = UIColor.colorFromHex(hexString: "#F9690E")
            default:
                color = UIColor.clear
            }
            
            cell.teacherRankWrapperView.backgroundColor = color
            
            cell.teacherRankWrapperView.layer.cornerRadius = cell.teacherRankWrapperView.frame.width / 2
            cell.teacherRankWrapperView.layer.borderColor = UIColor.white.cgColor
            cell.teacherRankWrapperView.layer.borderWidth = 2
            cell.rankLabel.text = "\(teacherRank)"

        }
        
        else{
            cell.teacherRankWrapperView.isHidden = true
        }
        
        
        let relatedTeacher = self.teachers[indexPath.row]
        
        var names = relatedTeacher.name.components(separatedBy: " ")
        let first_name = names.popLast()
        let last_name = names[0..<names.count].joined(separator:" ")
        
        KingfisherManager.shared.retrieveImage(with: URL(string: relatedTeacher.imageURL)!, options: [], progressBlock: nil, completionHandler: {
            image, error,cacheType, imageURL in
            
                cell.teacherImageView.layer.cornerRadius = cell.teacherImageView.frame.width / 2
                //cell.teacherImageView.layer.borderWidth = 1.5
                //cell.teacherImageView.layer.borderColor = UIColor.lightGray.cgColor
                cell.teacherImageView.image = image
                cell.teacherFirstNameLabel.text = first_name
                cell.teacherLastNameLabel.text = last_name
        })
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "DetailedTeacherViewController") as! DetailedTeacherViewController
        let teacher = self.teachers[indexPath.row]
        
        print(teacher)
        
        popup.teacher = teacher
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.pushViewController(popup, animated: true)
        
    }
    
    // MARK: - UICollectionView Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //UIScreen.mainScreen().bounds.width
    
        return CGSize(width: 88, height: 124)
        
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
    
    // MARK: - Utils
    
    // MARK: - Reading
    
    func updateCourseStatsLabels(){
        
        print(#function)
        let difficulty = Float((self.course.votes["difficulty"] as! [String: String])["value"]!)!
        print(difficulty)
        
        self.courseProfileView.difficultyLabel.text = Utilities.getDifficultyText(factor: difficulty, with: true)
        
        for (key, value) in self.course.votes{
            
            switch key {
            case "popularity":
                self.courseStatsView.popularityNumberLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(course.popularity)" : "--"
                self.courseStatsView.popularityVotesLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(Int((value as! [String: String])["count"]!)!) vote/s" : "no votes"
            case "difficulty":
                self.courseStatsView.difficultyVotesLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(course.difficulty)" : "--"
                self.courseStatsView.difficultyMessageLabel.text = Int((value
                    as! [String: String])["count"]!)! > 0 ? "\(Int((value as! [String: String])["count"]!)!) vote/s" : "no votes"
            case "workload":
                self.courseStatsView.workloadVotesLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(course.workload)" : "--"
                self.courseStatsView.workloadMessageLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(Int((value as! [String: String])["count"]!)!) vote/s" : "no votes"
            case "interesting":
                self.courseStatsView.interestingVotesLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(course.interesting)" : "--"
                self.courseStatsView.interestingMessageLabel.text = Int((value as! [String: String])["count"]!)! > 0 ? "\(Int((value as! [String: String])["count"]!)!) vote/s" : "no votes"
                
                
            default:
                ()
            }
        }
        
    }
    
    func updateStatsTimestamps(){
        
        /*for stat in self.statsTimestamps{
            
            let stat_number = (stat["stat"] as! NSString).intValue
            let lastTimestamp = (stat["last_timestamp"] as! NSString).intValue
            
            switch stat_number {
            case 0:
                self.courseStatsView.easyTimestampLabel.text = Utilities.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: TimeInterval(lastTimestamp)), numericDates: false)
            case 1:
                self.courseStatsView.normalTimestampLabel.text = Utilities.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: TimeInterval(lastTimestamp)), numericDates: false)
            case 2:
                self.courseStatsView.hardTimestampLabel.text = Utilities.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: TimeInterval(lastTimestamp)), numericDates: false)
            case 3:
                self.courseStatsView.impossibleTimestampLabel.text = Utilities.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: TimeInterval(lastTimestamp)), numericDates: false)
            
            default:
                continue
            }
            
        }*/
        
    }
    
    func updateStatsData(){
        
        for (key, value) in self.userVotes{
            
            let voted = Bool((value["voted"] as! NSString).intValue as NSNumber)
            
            if voted{
                
                switch key {
                case "popularity":
                    self.courseStatsView.votedPopularityLabel.isHidden = false
                    self.courseStatsView.popularityWrapperView.isVoted = true
                case "difficulty":
                    self.courseStatsView.votedDifficultyLabel.isHidden = false
                    self.courseStatsView.difficultyWrapperView.isVoted = true
                case "workload":
                    self.courseStatsView.votedWorkloadLabel.isHidden = false
                    self.courseStatsView.workloadWrapperView.isVoted = true
                case "interesting":
                    self.courseStatsView.votedInterestingLabel.isHidden = false
                    self.courseStatsView.interestingWrapperView.isVoted = true
                default:
                    ()
                }
                
            }
            
        }
    }
    
    func updateCourseVotes(){
        
        /*self.courseStatsView.easyVotesLabel.text = "\(self.course.easy)"
        self.courseStatsView.normalVotesLabel.text = "\(self.course.normal)"
        self.courseStatsView.hardVotesLabel.text = "\(self.course.hard)"
        self.courseStatsView.impossibleVotesLabel.text = "\(self.course.impossible)"
        self.courseStatsView.popularityNumberLabel.text = "\(self.course.popularity)"
        */
    }
    
    func updateVotedLabels(){
        
        /*if self.votedEasy == true{
            self.courseStatsView.votedEasyLabel.isHidden = false
            self.activeVotedLabel = self.courseStatsView.votedEasyLabel
        }
        
        else if self.votedNormal == true{
            self.courseStatsView.votedNormalLabel.isHidden = false
            self.activeVotedLabel = self.courseStatsView.votedNormalLabel
        }
        
        else if self.votedHard == true{
            self.courseStatsView.votedHardLabel.isHidden = false
            self.activeVotedLabel = self.courseStatsView.votedHardLabel
        }
        
        else if self.votedImpossible == true{
            self.courseStatsView.votedImpossibleLabel.isHidden = false
            self.activeVotedLabel = self.courseStatsView.votedImpossibleLabel
        }
        
        if self.votedPopularity == true{
            self.courseStatsView.votedPopularityLabel.isHidden = false
        }
        */
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
    
    func checkIfCourseIsSaved(){
        
        let isSaved = Utilities.isCourseSaved(sigla: self.course.sigla)
        let newButton = UIBarButtonItem(barButtonSystemItem: isSaved ? .trash : .add, target: self, action: #selector(toggleCoursePressed(_:)))
        self.navigationItem.setRightBarButton(newButton, animated: false)
    }
    
    func getSavedCourseEntity() -> Any?{
        
        for course in self.userCourses{
            if course.sigla == self.course.sigla{
                return course
            }
        }
        
        return nil
        
    }

    
    // MARK: - Actions
    
    @IBAction func toggleCoursePressed(_ sender: Any) {
        
        print("toggle button presssed")
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleUserCourse"), object: course)
        
        let isSaved = Utilities.isCourseSaved(sigla: self.course.sigla)
        let newButton = UIBarButtonItem(barButtonSystemItem: isSaved ? .add : .trash, target: self, action: #selector(toggleCoursePressed(_:)))
        self.navigationItem.setRightBarButton(newButton, animated: true)
    
    }
    
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
    
    // MARK: - Notifications
    
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
        customView.statTitleLabel.text = "Rate this course \(statName)"
        
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
                
                switch statName{
                case "popularity":
                    statNumber = 0
                case "difficulty":
                    statNumber = 1
                case "workload":
                    statNumber = 2
                case "interesting":
                    statNumber = 3
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
                
                print(self.course.name)
                
                let parameters = ["stat": statNumber, "sigla": self.course.sigla, "value": value, "user_key": self.appDelegate.userKey, "action": "vote"] as [String : Any]
                self.service.submitAction(url: self.settings.postCourseStat, parameters: parameters, callback: { response in
                 
                     print(response)
                     
                     //let vote = Vote(value: Int32(value)!, type: Int32(statNumber), timestamp: -1)
                     
                     //thanks for voting message
                     DispatchQueue.main.async {
                         let notification = CWStatusBarNotification()
                         notification.backgroundColor = self.settings.notificationColor
                         notification.animationInStyle = self.settings.animationInStyle
                         notification.animationOutStyle = self.settings.animationOutStyle
                         notification.style = self.settings.notificationStyle
                         notification.notificationLabel?.font = self.settings.notificationFont
                         notification.displayNotification(message: self.settings.thanksForVotingText, duration: 2)
                         
                         //self.updateTeacherStats()
                     }
                 
                 
                 })
                
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(somethingAction)
        
        if isVoted{
            let removeAction = UIAlertAction(title: "Remove vote", style: .destructive, handler: {(alert: UIAlertAction!) in print("remove-vote")})
            alertController.addAction(removeAction)
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
        
        
    }
    
    
}
