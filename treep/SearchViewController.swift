//
//  SearchViewController.swift
//  treep
//
//  Created by Andre Simon on 12/13/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    var teachers = [Teacher]()
    var courses = [Course]()
    var filteredTeachers = [Teacher]()
    let searchController = UISearchController(searchResultsController: nil)
    let settings = Settings()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchWrapperView: UIView!

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teachers = []

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.searchController.searchBar.searchBarStyle = .minimal
        
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        registerNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        return section == 0 ? "Teachers": "Courses"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            if searchController.isActive && self.searchController.searchBar.text != "" {
                return filteredTeachers.count
            }
            
            else{
                return 0
            }
        }
        
        else{
            return courses.count
        }
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.selectionStyle = .none

        
        //teachers
        if indexPath.section == 0{
            let teacher: Teacher
            if searchController.isActive && self.searchController.searchBar.text != "" {
                teacher = filteredTeachers[indexPath.row]
            } else {
                teacher = teachers[indexPath.row]
            }
            
            print("updating")
            cell.titleLabel.text = teacher.name
            cell.subtitleLabel.text = "\(teacher.factor)"
            cell.addButton.isHidden = true
        }
        
        //courses
        else{
            let course = courses[indexPath.row]
            cell.titleLabel.text = course.name
            cell.subtitleLabel.text = course.sigla
            cell.addButton.isHidden = false

            cell.addButton.setTitle(Utilities.isCourseSaved(sigla: course.sigla) ? "REMOVE" : "ADD", for: .normal)
            cell.addButton.setTitleColor(Utilities.isCourseSaved(sigla: course.sigla) ? .red : self.view.tintColor, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            
            let popup = self.storyboard?.instantiateViewController(withIdentifier: "DetailedTeacherViewController") as! DetailedTeacherViewController
            let teacher = self.filteredTeachers[indexPath.row]
            
            popup.teacher = teacher
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            self.navigationController?.pushViewController(popup, animated: true)
            
        }
        
        else{
            let courseViewController = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
            courseViewController.course = self.courses[indexPath.row]
            
            self.navigationController?.pushViewController(courseViewController, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let query = searchText
        var courseFinished = false
        var teacherFinished = false
        
        if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchWrapperView.alpha = 0
            })
            
            let parameters: Parameters = ["q": query, "user_key": self.appDelegate.userKey]
            var searchTeachers = [Teacher]()
            
            Alamofire.SessionManager.default.session.getAllTasks { tasks in
                tasks.forEach { $0.cancel() }
            }
            
            Utilities.startActivityIndicator()
            
            Alamofire.request(settings.searchTeachers, parameters: parameters)
                .responseJSON(completionHandler: {
                    response in
                    
                    teacherFinished = true
                    
                    if teacherFinished && courseFinished{
                        Utilities.stopActivityIndicator()
                    }
                    
                    if let json = response.result.value as? [String: Any]{
                        
                        print(json)
                        
                        let teachers = json["teachers"] as! NSArray
                        
                        for teacher in teachers{
                            
                            let teacher_data = teacher as! [String: Any]
                            
                            
                            if (teacher_data["name"] as? String) != nil{
                                
                                let _teacher = Utilities.readTeacher(teacher_data: teacher_data)
                                
                                searchTeachers.append(_teacher)
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.filteredTeachers.removeAll()
                            self.filteredTeachers.append(contentsOf: searchTeachers)
                            //self.tableView.reloadData()
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                            
                        }
                        
                    }
                    
                })
            
            var searchCourses = [Course]()
            
            Alamofire.request(settings.getCourses, parameters: parameters)
                .responseJSON(completionHandler: { response in
                    
                    courseFinished = true
                    
                    if teacherFinished && courseFinished{
                        Utilities.stopActivityIndicator()
                    }
                    
                    if let json = response.result.value as? [String: Any]{
                        print(json)
                        
                        let courses = json["courses"] as! NSArray
                        
                        for course in courses{
                            
                            let course_data = course as! [String: Any]
                            
                            let _course = Utilities.readCourse(course_data: course_data)
                            
                            searchCourses.append(_course)
                            
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.courses.removeAll()
                            self.courses.append(contentsOf: searchCourses)
                            //self.tableView.reloadData()
                            print(self.courses.count)
                            self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
                            
                        }
                        
                    }
                    
                })

        }
            
        else{
            print("empty")
            UIView.animate(withDuration: 0.3, animations: {
                self.searchWrapperView.alpha = 1
            })
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        /*filteredTeachers = teachers.filter({( teacher : Teacher) -> Bool in
            return teacher.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        */
    }
    
    // MARK: - Navigation
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let teacher: Teacher
                if searchController.isActive && searchController.searchBar.text != "" {
                    teacher = filteredTeachers[indexPath.row]
                } else {
                    teacher = teachers[indexPath.row]
                }
                let controller = segue.destination as! DetailedTeacherViewController
                controller.teacher = teacher
                self.navigationItem.backBarButtonItem?.title = ""
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
                //controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                //controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }*/
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Notifications
    
    func registerNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleCourseButtonPressed(_:)), name: NSNotification.Name("ToggleUserCourseIndex"), object: nil)
        
    }
    
    func toggleCourseButtonPressed(_ notification: Notification){
        
        //update ui
        
        let index = notification.object as! Int
        let course = self.courses[index]
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleUserCourse"), object: course)
        
        tableView.reloadData()

    }

}


extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchWrapperView.alpha = 1
        }, completion: { Bool in
            self.filteredTeachers.removeAll()
            self.courses.removeAll()
            self.tableView.reloadData()
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        print("updating results")
        filterContentForSearchText(self.searchController.searchBar.text!)
    }
}
