//
//  BestStatsViewController.swift
//  treep
//
//  Created by Andre Simon on 4/24/17.
//  Copyright © 2017 Andre Simon. All rights reserved.
//

import UIKit
import Alamofire

class BestStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var titleViewWrapper: UIView!
    @IBOutlet weak var statImageView: UIImageView!
    @IBOutlet weak var statMessageLabel: UILabel!
    @IBOutlet weak var tableViewWrapperView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var statObjects = [Any]()
    var statType: String!
    var settings = Settings()
    
    var bestTeologicosMessage = "These are the best teológicos based on their popularity and the number of searches that they have."
    var bestTeacherMessage = "These are the best teachers based on their popularity and their stats."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "BestStatCell", bundle: nil), forCellReuseIdentifier: "BestStatCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        self.titleViewWrapper.layer.cornerRadius = 5
        
        print("showing: \(statType)")
        
        let sortButton = UIBarButtonItem(image: UIImage(named: "sort-2"), style: .plain, target: self, action: #selector(sortStatsButtonPressed))
        let searchButton = UIBarButtonItem(image: UIImage(named: "search-44"), style: .plain, target: self, action: #selector(sortStatsButtonPressed))
        
        navigationItem.rightBarButtonItems = [sortButton, searchButton]

        
        updateStatMessage()
        
        if ["teologicos", "teachers"].contains(self.statType){
            
            loadingActivityIndicator.startAnimating()   
            
            let parameters: Parameters = ["stat": statType, "user_key": appDelegate.userKey]
            Alamofire.request(self.settings.getBestStat, parameters: parameters)
                .responseJSON(completionHandler: { response in
                    
                    if let json = response.result.value as? [String: Any]{
                        
                        print(json)
                        
                        let bests = json["response"] as! NSArray
                        
                        for best in bests{
                            
                            let best_data = best as! [String: Any]
                            
                            var _best: Any
                            
                            switch self.statType{
                            case "teologicos":
                                _best = Utilities.readCourse(course_data: best_data)
                                self.statObjects.append(_best)
                                
                            case "teachers":
                                _best = Utilities.readTeacher(teacher_data: best_data)
                                self.statObjects.append(_best)
                                self.statImageView.image = UIImage(named: "gradient-7")
                                
                            default:
                                break
                            }
                            
                        }
                        
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.tableViewWrapperView.alpha = 0
                            self.loadingActivityIndicator.stopAnimating()
                        })
                        
                        self.tableView.reloadData()
                        
                        
                    }
                    
                    
                })
            
            
        }
            
        else{
            print("hiding table")
            
            loadingActivityIndicator.isHidden = true
            loadingLabel.text = "Sorry. Stat not available yet."
            
        }

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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.statObjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BestStatCell", for: indexPath) as! BestStatCell
        cell.selectionStyle = .none
        
        switch statType {
            
        case "teologicos":
            let best = self.statObjects[indexPath.row] as! Course
            
            // Configure the cell...
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.statTarget.text = "\(best.sigla) - \(best.name)"
            cell.secondaryLabel.text = "\(Utilities.getDifficultyText(factor: best.difficulty, with: true))"
            cell.thirdLabel.isHidden = true
            
            
        case "teachers":
            
            let best = self.statObjects[indexPath.row] as! Teacher
            
            // Configure the cell...
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.statTarget.text = "\(best.name)"
            cell.secondaryLabel.text = "\(best.factor)"
            //cell.secondaryLabel.text = "\(Utilities.getDifficultyText(factor: Utilities.calculateDifficulty(course: best)))"
            cell.thirdLabel.isHidden = true
            
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch statType {
        case "teologicos":
            let object = self.statObjects[indexPath.row] as! Course
            let popup = self.storyboard?.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
            popup.course = object
            
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            self.navigationController?.pushViewController(popup, animated: true)
        case "teachers":
            let object = self.statObjects[indexPath.row] as! Teacher
            let popup = self.storyboard?.instantiateViewController(withIdentifier: "DetailedTeacherViewController") as! DetailedTeacherViewController
            popup.teacher = object
            
            self.navigationItem.backBarButtonItem?.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            self.navigationController?.pushViewController(popup, animated: true)
        default:
            break
        }

    }

    
    // MARK: - UI
    
    func updateStatMessage(){
        
        switch statType {
        case "teologico":
            statMessageLabel.text = bestTeologicosMessage
            
        case "teachers":
            statMessageLabel.text = bestTeacherMessage
        default:
            break
        }
        
    }
    
    // MARK: - Actions
    
    func sortStatsButtonPressed(){
        
        
        let alertController = UIAlertController(title: "Sort \(statType!) by", message: nil, preferredStyle: .actionSheet)
        
        switch statType {
        case "teologicos":
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("cancel")
            }
            
            let popularityAction = UIAlertAction(title: "Popularity", style: .default) { action in
                print("Popularity")
                self.statObjects = self.statObjects.sorted(by: { ($0 as! Course).popularity > ($1 as! Course).popularity })
                
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                
                self.navigationItem.titleView = Utilities.setTitle(title: "Teológicos", subtitle: "popularity")

            }
            
            let difficultyAction = UIAlertAction(title: "Difficulty", style: .default) { action in
                print("difficulty")
                
                self.statObjects = self.statObjects.sorted(by: { ($0 as! Course).difficulty > ($1 as! Course).difficulty })
                
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                
                self.navigationItem.titleView = Utilities.setTitle(title: "Teológicos", subtitle: "difficulty")
            }
            
            let interestingAction = UIAlertAction(title: "Interesting", style: .default) { action in
                print("interesting")
                
                self.statObjects = self.statObjects.sorted(by: { ($0 as! Course).interesting > ($1 as! Course).interesting })
                
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                
                self.navigationItem.titleView = Utilities.setTitle(title: "Teológicos", subtitle: "interesting")
            }
            
            let workloadAction = UIAlertAction(title: "Workload", style: .default) { action in
                print("workload")
                
                self.statObjects = self.statObjects.sorted(by: { ($0 as! Course).workload > ($1 as! Course).workload })
                
                let range = NSMakeRange(0, self.tableView.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
                
                self.navigationItem.titleView = Utilities.setTitle(title: "Teológicos", subtitle: "workload")
            }
            
            
            let actions = [cancelAction, popularityAction, difficultyAction, interestingAction, workloadAction]
            
            for action in actions{
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true) {
                print("nice")
            }
            

        case "teachers":
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("Cancel")
            }
            
            let clarityAction = UIAlertAction(title: "Clarity", style: .default) { action in
                print("Popularity")
            }
            
            let dispositionAction = UIAlertAction(title: "Disposition", style: .default) { action in
                print("Disposition")
            }
            
            let exigencyAction = UIAlertAction(title: "Exigency", style: .default) { action in
                print("Exigency")
            }
            
            let knowledgeAction = UIAlertAction(title: "Knowledge", style: .default) { action in
                print("Knowledge")
            }
            
            
            let actions = [cancelAction, clarityAction, dispositionAction, exigencyAction, knowledgeAction]
            
            for action in actions{
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true) {
                print("nice")
            }
            
        default:
            break
        }
        
        
    }


}
