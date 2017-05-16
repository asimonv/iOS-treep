//
//  RankingsViewController.swift
//  treep
//
//  Created by Andre Simon on 12/20/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RankingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var topRankingsWrapperView: UIView!
    @IBOutlet weak var homeStatsWrapperView: UIView!
    @IBOutlet weak var userCoursesWrapperView: UIView!
    
    var rankingsView: RankingsView!
    var statsView: HomeStatsView!
    var userCoursesView: UserCoursesView!
    var userSavedCourses = [CourseData]()
    var userCourses = [Course]()
    var service = Service()
    var settings = Settings()
    var userCoursesLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.rankingsView = RankingsView.instanceFromNib()
        self.statsView = HomeStatsView.instanceFromNib()
        self.userCoursesView = UserCoursesView.instanceFromNib()
        self.userCoursesView.translatesAutoresizingMaskIntoConstraints = false
       
        self.topRankingsWrapperView.addSubview(self.rankingsView)
        self.homeStatsWrapperView.addSubview(self.statsView)
        self.userCoursesWrapperView.addSubview(self.userCoursesView)
        
        
        let topContraint = NSLayoutConstraint(item: self.userCoursesView, attribute: .topMargin, relatedBy: .equal, toItem: self.userCoursesWrapperView, attribute: .topMargin, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.userCoursesView, attribute: .bottomMargin, relatedBy: .equal, toItem: self.userCoursesWrapperView, attribute: .bottomMargin, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.userCoursesView, attribute: .trailingMargin, relatedBy: .equal, toItem: self.userCoursesWrapperView, attribute: .trailingMargin, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self.userCoursesView, attribute: .leadingMargin, relatedBy: .equal, toItem: self.userCoursesWrapperView, attribute: .leadingMargin, multiplier: 1, constant: 0)
        
        self.userCoursesWrapperView.addConstraints([topContraint, bottomConstraint, trailingConstraint, leadingConstraint])
        
        self.rankingsView.collectionView.dataSource = self
        self.rankingsView.collectionView.delegate = self
        
        self.userCoursesView.collectionView.dataSource = self
        self.userCoursesView.collectionView.delegate = self
        
        self.rankingsView.collectionView.register(UINib(nibName: "RankingCell", bundle: nil), forCellWithReuseIdentifier: "RankingCell")
        self.userCoursesView.collectionView.register(UINib(nibName: "UserCourseCell", bundle: nil), forCellWithReuseIdentifier: "UserCourseCell")
        
        self.statsView.totalCoursesVotesWrapperView.layer.cornerRadius = 5
        self.statsView.totalTeacherVotesWrapperView.layer.cornerRadius = 5
        self.userCoursesWrapperView.layer.cornerRadius = 5
        self.userCoursesView.collectionView.layer.cornerRadius = 5
        
        let noCoursesMessage = NSMutableAttributedString(string: "Search for a course and click the ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)])
        
        let plusPart = NSAttributedString(string: "+", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white])
        let orPart = NSAttributedString(string: " (or ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)])
        let addPart = NSAttributedString(string: "ADD", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white])
        let restPart = NSAttributedString(string: ") button to add one and treep will tell you how hard is your semester.", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)])
        
        noCoursesMessage.append(plusPart)
        noCoursesMessage.append(orPart)
        noCoursesMessage.append(addPart)
        noCoursesMessage.append(restPart)
        
        self.userCoursesView.noCoursesMessageLabel.attributedText = noCoursesMessage
        
        registerNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.userSavedCourses = Utilities.getSavedCoursesEntities() as! [CourseData]
        self.userCoursesLoaded = false
        
        if self.userSavedCourses.count > 0{
            
            self.userCoursesView.noCoursesWrapperView.alpha = 0
            self.userCoursesView.clearButton.alpha = 1
            self.userCoursesView.semesterAnalysisLabel.alpha = 1
            
            let parameters = ["user_courses": self.userSavedCourses.map({x in x.sigla})]
            print("user courses: \(parameters)")
            service.submitAction(url: settings.getUserCoursesStats, parameters: parameters, callback: { response in
                
                print(response)
                self.userCoursesLoaded = true
                
                let courses = response["courses"]
                self.userCourses.removeAll()
                
                for course in courses{
                    let _course = Utilities.readUserCourse(course_data: course.1.dictionaryObject!)
                    self.userCourses.append(_course)
                }
                
                DispatchQueue.main.async {
                    self.reloadCollectionView(self.userCoursesView.collectionView)
                    
                    self.updateSemesterDifficultyMessage()
                }
            })
        }
        
        else{
            self.userCoursesView.noCoursesWrapperView.alpha = 1
            self.userCoursesView.clearButton.alpha = 0
            self.userCoursesView.semesterAnalysisLabel.alpha = 0
        }
        
        let parameters: Parameters = [:]
        Alamofire.request(self.settings.getStats, parameters: parameters)
            .responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [String: Any]{
                    
                    self.updateStats(data: json["response"] as! [String : Any?])
                    
                }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helpers
    
    func registerNotifications(){
        let notificationName = Notification.Name("removeUserCourseButtonPressed")
        NotificationCenter.default.addObserver(self, selector: #selector(userCourseCellRemoveButtonPressed(notification:)), name: notificationName, object: nil)
        
        let teacherButtonPressedNotificationName = Notification.Name("TeacherButtonPressed")
        NotificationCenter.default.addObserver(self, selector: #selector(teacherButtonPressed(notification:)), name: teacherButtonPressedNotificationName, object: nil)
        
        let toggleUserCourseName = Notification.Name("ToggleUserCourse")
        NotificationCenter.default.addObserver(self, selector: #selector(toggleUserCourse(_:)), name: toggleUserCourseName, object: nil)
        
        let clearCoursesName = Notification.Name("ClearUserCourses")
        NotificationCenter.default.addObserver(self, selector: #selector(clearCourses(_:)), name: clearCoursesName, object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.rankingsView.collectionView{
            
            let popup = self.storyboard?.instantiateViewController(withIdentifier: "BestStatsViewController") as! BestStatsViewController
            
            
            print((indexPath.section, indexPath.row))
            
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                popup.statType = "teologicos"
                popup.navigationItem.title = "Teológicos"
            case (0,1):
                popup.statType = "courses"
                popup.navigationItem.title = "Courses"
            case (1,0):
                popup.statType = "ofgs"
                popup.navigationItem.title = "OFGs"
            case (1,1):
                popup.statType = "teachers"
                popup.navigationItem.title = "Teachers"
            default:
                break
            }
            
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            
            self.navigationController?.pushViewController(popup, animated: true)
            
        }
        
        else{
            
            let popup = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
            popup.course = self.userCourses[indexPath.row]
            
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            
            self.navigationController?.pushViewController(popup, animated: true)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.rankingsView.collectionView{
            return 2
        }
        
        return self.userSavedCourses.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == self.rankingsView.collectionView{
            return 2
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.rankingsView.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCell", for: indexPath) as! RankingCell
            
            cell.layer.cornerRadius = 7
            
            switch indexPath.row {
            case 0:
                
                switch indexPath.section {
                case 0:
                    cell.categoryLabel.text = "Teológicos"
                    cell.categoryImageView.image = UIImage(named: "matisse-12")
                    cell.backgroundColor = UIColor.colorFromHex(hexString: "#7f00ff")
                case 1:
                    cell.categoryLabel.text = "OFGs"
                    cell.backgroundColor = UIColor.colorFromHex(hexString: "#E87E04")
                    cell.categoryImageView.image = UIImage(named: "matisse-13")
                default:
                    cell.categoryLabel.text = ""
                }
            case 1:
                
                switch indexPath.section {
                case 0:
                    cell.categoryLabel.text = "Courses"
                    cell.backgroundColor = UIColor.colorFromHex(hexString: "#F64747")
                    cell.categoryImageView.image = UIImage(named: "matisse-6")
                case 1:
                    cell.categoryLabel.text = "Teachers"
                    cell.backgroundColor = UIColor.colorFromHex(hexString: "#B12646")
                    cell.categoryImageView.image = UIImage(named: "matisse-11")
                default:
                    cell.categoryLabel.text = ""
                }
                
            default:
                cell.categoryLabel.text = ""
            }
            
            return cell

        }
        
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCourseCell", for: indexPath) as! UserCourseCell
            
            if self.userCoursesLoaded{
                
                let course = self.userCourses[indexPath.row]
                
                cell.courseNameLabel.text = "\(course.sigla) - \(course.name)"
                cell.difficultyLabel.text = Utilities.getDifficultyText(factor: course.difficulty, with: false)
                
                if course.bestTeacher != nil{
                    cell.teacherNameButton.setTitle(course.bestTeacher?.name, for: .normal)
                    cell.teacherNameButton.isEnabled = true
                }
                
                else{
                    cell.teacherNameButton.setTitle("No best teacher available", for: .normal)
                    cell.teacherNameButton.isEnabled = false
                }
                
                
                
                cell.layer.cornerRadius = 7
                
                return cell
                
            }
            
            else{
                let course = self.userSavedCourses[indexPath.row]
                
                cell.courseNameLabel.text = "\(course.sigla) - \(course.name)"
                
                cell.layer.cornerRadius = 7
                
                return cell
            }
            
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.rankingsView.collectionView{
            return CGSize(width: self.rankingsView.collectionView.frame.width/2 - 3, height: self.rankingsView.collectionView.frame.width/2 - 3)
        }
        
        return CGSize(width: self.userCoursesView.collectionView.frame.width - 3, height: self.userCoursesView.collectionView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == self.rankingsView.collectionView{
            return 6
        }
        
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == self.rankingsView.collectionView{
            return UIEdgeInsetsMake(0, 0, 6, 0)
        }
        
        return UIEdgeInsetsMake(0, 0, 0, 3)
        
    }
    
    func reloadCollectionView(_ collectionView: UICollectionView) {
        let contentOffset = collectionView.contentOffset
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(contentOffset, animated: false)
    }
    
    
    
    
    // MARK: - Notifications
    
    func clearCourses(_ notitication: Notification){
        
        for course in userCourses{
            removeCourseFromCoreData(course.sigla)
        }
        
        if self.userCourses.count == 0{
            
            UIView.transition(with: self.userCoursesView.creditsLabel,
                                      duration: 0.3,
                                      options: [.transitionCrossDissolve],
                                      animations: {
                                        self.userCoursesView.creditsLabel.text = "0 CR"
                                        
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.userCoursesView.noCoursesWrapperView.alpha = 1
                self.userCoursesView.clearButton.alpha = 0
                self.userCoursesView.semesterAnalysisLabel.alpha = 0
            })
        }
        
        self.userCoursesView.collectionView.reloadData()
        
    }
    
    func toggleUserCourse(_ notification: Notification){
        
        //notification gets sigla -> toggle user course based on sigla
        print(#function)
        
        let course = notification.object as! Course
        
        print(course)
        
        //course already added
        if isUserCourseSaved(sigla: course.sigla){
            //remove
            print("removing")
            removeCourseFromCoreData(course.sigla)
            
            //show notification
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

            
            //send notification to update row
            
        }
        
        //course not added
        else{
            //add
            print("adding")
            saveCourseToCoreData(course.name, sigla: course.sigla)
            self.userCourses.append(course)
            
            //show notification
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

            
            //send notification to update row
            
        }
        
        
    }
    
    func teacherButtonPressed(notification: Notification){
        
        let object = notification.object as! [String: Any]
        let courseIndexPath = object["indexPath"] as! IndexPath
        
        let teacher = userCourses[courseIndexPath.row].bestTeacher
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "DetailedTeacherViewController") as! DetailedTeacherViewController
        popup.teacher = teacher
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        self.navigationController?.pushViewController(popup, animated: true)

        
    }
    
    func userCourseCellRemoveButtonPressed(notification: Notification){
        
        let object = notification.object as! [String: Any]
        let indexPath = object["indexPath"] as! IndexPath
        
        self.userCoursesView.collectionView.performBatchUpdates({
            self.userCoursesView.collectionView.deleteItems(at: [indexPath])
            self.userCourses.remove(at: indexPath.row)
            
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let object = self.userSavedCourses[indexPath.row] as CourseData
                
            managedContext.delete(object)
            
            //4
            do {
                try managedContext.save()
                
                self.userSavedCourses.remove(at: indexPath.row)
                
                self.updateSemesterDifficultyMessage()
                
                if self.userCourses.count == 0{
                    UIView.animate(withDuration: 0.3, animations: {
                        self.userCoursesView.noCoursesWrapperView.alpha = 1
                        self.userCoursesView.clearButton.alpha = 0
                        self.userCoursesView.semesterAnalysisLabel.alpha = 0
                    })
                }
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            

        
        }, completion: { Bool in
            
        })
        
    }
    
    // MARK: - Updating Frontend
    
    func updateSemesterDifficultyMessage(){
        self.userCoursesView.semesterAnalysisLabel.text = Utilities.getDifficultyTextForSemester(courses: self.userCourses)
        
        UIView.transition(with: self.userCoursesView.semesterAnalysisLabel,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.userCoursesView.semesterAnalysisLabel.text = Utilities.getDifficultyTextForSemester(courses: self.userCourses)
                            
        }, completion: nil)
        
        UIView.transition(with: self.userCoursesView.creditsLabel,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.userCoursesView.creditsLabel.text = "\(self.userCourses.map({x in x.credits}).reduce(0, +)) CR"
                            
        }, completion: nil)
    
    }
    
    func updateStats(data: [String: Any?]){
        
        let courses_stats = data["courses_stats"] as! [String: String]
        let teacher_stats = data["teachers_stats"] as! [String: String]
        
        statsView.totalCoursesVotesLabel.text = courses_stats["total_votes"]
        statsView.coursesTimestampLabel.text = Utilities.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: TimeInterval(Int(courses_stats["last_timestamp"]!)!)), numericDates: false)
        
        statsView.totalTeacherVotesLabel.text = teacher_stats["total_votes"]
        statsView.teacherTimestampLabel.text = Utilities.timeAgoSinceDate(date: NSDate(timeIntervalSince1970: TimeInterval(Int(teacher_stats["last_timestamp"]!)!)), numericDates: false)

        
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
            self.userSavedCourses.insert(course, at: 0)
            
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func removeCourseFromCoreData(_ sigla: String){
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let object = getSavedCourseEntity(sigla: sigla) as? CourseData{
            
            managedContext.delete(object)
            
            if let index = self.userSavedCourses.index(of: object){
                
                self.userCourses.remove(at: index)
                self.userSavedCourses.remove(at: index)
                
                //4
                do {
                    try managedContext.save()
                    
                } catch let error as NSError  {
                    print("Could not remove \(error), \(error.userInfo)")
                }
                
                
            }
            
        }

    }
    
    func getSavedCourseEntity(sigla: String) -> Any?{
        
        for course in self.userSavedCourses{
            if course.sigla == sigla{
                return course
            }
        }
        
        return nil
        
    }
    
    func getUserCourse(sigla: String) -> Any?{
        
        for course in self.userCourses{
            if course.sigla == sigla{
                return course
            }
        }
        
        return nil
        
    }
    
    func isUserCourseSaved(sigla: String) -> Bool{
        
        for course in self.userCourses{
            if course.sigla == sigla{
                return true
            }
        }
        
        return false
        
    }
}
