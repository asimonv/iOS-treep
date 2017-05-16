//
//  Utilities.swift
//  treep
//
//  Created by Andre Simon on 12/29/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit
import CoreData

class Utilities {
    
    class func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        
        let subtitleText = NSMutableAttributedString(string: "sorted by: ", attributes: [NSFontAttributeName: subtitleLabel.font])
        subtitleText.append(NSMutableAttributedString(string: subtitle, attributes: [NSFontAttributeName: subtitleLabel.font, NSForegroundColorAttributeName: UIColor.black]))
        subtitleLabel.attributedText = subtitleText
        
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            
            titleLabel.frame = frame.integral
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = frame.integral
        }
        
        return titleView
    }
    
    class func readUserCourse(course_data: [String: Any]) -> Course{
        
        let course: Course!
        
        let sigla = course_data["sigla"] as! String
        let name = course_data["name"] as! String
        let stats = course_data["stats"] as! [String: Any]
        
        var popularity: Int32 = 0
        var difficulty: Float = 0
        var workload: Float = 0
        var interesting: Float = 0
        
        let factor: Float = (course_data["factor"] as! NSString).floatValue
        
        var votes = [String: Any]()
        
        for (key, value) in stats{
            
            let statData = value as! [String: Any]
            
            switch key {
            case "popularity":
                popularity = (statData["value"] as! NSString).intValue
                votes["popularity"] = (statData["count"] as! NSString).intValue
            case "difficulty":
                difficulty = (statData["value"] as! NSString).floatValue
                votes["difficulty"] = (statData["count"] as! NSString).intValue
            case "workload":
                workload = (statData["value"] as! NSString).floatValue
                votes["workload"] = (statData["count"] as! NSString).intValue
            case "interesting":
                interesting = (statData["value"] as! NSString).floatValue
                votes["interesting"] = (statData["count"] as! NSString).intValue
            default:
                ()
            }
            
            
        }
        
        let id = (course_data["id"] as! NSString).intValue
        let credits = (course_data["credits"] as! NSString).intValue
        
        if !(course_data["best_teacher"] is NSNull) {
            
            let bestTeacherData = course_data["best_teacher"] as! [String: Any]
            let bestTeacher = readTeacher(teacher_data: bestTeacherData)
            
            course = Course(id: id, popularity: popularity, difficulty: difficulty, workload: workload, interesting: interesting, sigla: sigla, name: name, credits: credits, votes: votes, factor: factor, bestTeacher: bestTeacher)
        }
        
        else{
            course = Course(id: id, popularity: popularity, difficulty: difficulty, workload: workload, interesting: interesting, sigla: sigla, name: name, credits: credits, votes: votes, factor: factor)
        }
        
        
        return course
    }
    
    class func readCourse(course_data: [String: Any]) -> Course{
        
        let sigla = course_data["sigla"] as! String
        let name = course_data["name"] as! String
        let stats = course_data["stats"] as! [String: Any]
        
        var popularity: Int32 = 0
        var difficulty: Float = 0
        var workload: Float = 0
        var interesting: Float = 0
        
        let factor: Float = (course_data["factor"] as! NSString).floatValue
        
        var votes = [String: Any]()
        
        for (key, value) in stats{
            
            let statData = value as! [String: Any]
            
            switch key {
            case "popularity":
                popularity = (statData["value"] as! NSString).intValue
                votes["popularity"] = (statData["count"] as! NSString).intValue
            case "difficulty":
                difficulty = (statData["value"] as! NSString).floatValue
                votes["difficulty"] = (statData["count"] as! NSString).intValue
            case "workload":
                workload = (statData["value"] as! NSString).floatValue
                votes["workload"] = (statData["count"] as! NSString).intValue
            case "interesting":
                interesting = (statData["value"] as! NSString).floatValue
                votes["interesting"] = (statData["count"] as! NSString).intValue
            default:
                ()
            }

            
        }
        
        let id = (course_data["id"] as! NSString).intValue
        let credits = (course_data["credits"] as! NSString).intValue
        
        let course = Course(id: id, popularity: popularity, difficulty: difficulty, workload: workload, interesting: interesting, sigla: sigla, name: name, credits: credits, votes: stats, factor: factor)
        
        return course
    }
    
    class func readTeacher(teacher_data: [String: Any]) -> Teacher{
        
        let teacher_name = teacher_data["name"] as! String
        let imageURL = teacher_data["img_url"] as! String
        let factor = (teacher_data["factor"] as! NSString).floatValue
        
        let stats = teacher_data["stats"] as! [String: Any]
        
        var votes = [String: Any]()
        var popularity: Int32 = 0
        var disposition: Float = 0
        var exigency: Float = 0
        var knowledge: Float = 0
        var clarity: Float = 0
        
        for (key, value) in stats{
            
            let statData = value as! [String: Any]
            
            switch key {
            case "popularity":
                popularity = (statData["value"] as! NSString).intValue
                votes["popularity"] = (statData["count"] as! NSString).intValue
            case "disposition":
                disposition = (statData["value"] as! NSString).floatValue
                votes["disposition"] = (statData["count"] as! NSString).intValue
            case "exigency":
                exigency = (statData["value"] as! NSString).floatValue
                votes["exigency"] = (statData["count"] as! NSString).intValue
            case "knowledge":
                knowledge = (statData["value"] as! NSString).floatValue
                votes["knowledge"] = (statData["count"] as! NSString).intValue
            case "clarity":
                clarity = (statData["value"] as! NSString).floatValue
                votes["clarity"] = (statData["count"] as! NSString).intValue
            default:
                ()
            }
            
            
        }
        
        let id = (teacher_data["id"] as! NSString).intValue
        
        let _teacher = Teacher(imageURL: imageURL, name: teacher_name, id: id, popularity: popularity, disposition: disposition, exigency: exigency, knowledge: knowledge, clarity: clarity, factor: factor, votes: stats)
        
        return _teacher
    }
    
    class func calculateSemesterDifficulty(courses: [Course]) -> Double{
        
        //maravilloso
        /*let stats = [Int(course.easy), Int(course.normal), Int(course.hard), Int(course.impossible)]
        let multipliers = [2,1,-1,-2]
        let total = stats.reduce(0,+)
        
        return total == 0 ? -3:Double((zip(stats, multipliers).map(*)).reduce(0, +))/Double(total)*/
        
        let difficulty = Double(courses.map({x in x.difficulty}).reduce(0, +))*0.6/Double(courses.count) + 0.4*Double(courses.map({x in x.workload}).reduce(0,+))/Double(courses.count)
        
        
        return difficulty
        
    }
    
    class func getDifficultyTextForSemester(courses: [Course]) -> String{
        
        let factor = calculateSemesterDifficulty(courses: courses)
        let credits = courses.map({x in x.credits}).reduce(0, +)
        var result = ""
        
        print(factor)
        print(credits)
        
        switch factor {
        case 1.5 ... 2: //easy
            
            if credits > 50{
                result = "Normal"
            }
            
            else{
                result = "Easy"
            }
            
        case 0 ..< 1.5: //normal
            
            if credits > 55{
                result = "Hard"
            }
                
            else if credits == 50{
                result = "Normal"
            }
            
            else{
                result = "Easy"
            }
            
        case -1.5 ..< 0: //hard
            
            if credits >= 50 && credits < 60{
                result = "Hard"
            }
                
            else if credits == 60{
                result = "Very Hard"
            }
                
            else if credits < 50 && credits >= 40{
                result = "Normal"
            }
            
            else{
                result = "Easy"
            }
            
        case -2 ..< -1.5:
            
            
            if credits >= 50 && credits < 60{
                result = "Very Hard"
            }
                
            else if credits == 60{
                result = "Exceedingly Hard"
            }
                
            else if credits < 50 && credits >= 40{
                result = "Hard"
            }
                
            else if credits == 30{
                result = "Normal"
            }
            
            else{
                result = "Easy"
            }
            
        default:
            result = "No Data"
        }
        
        /*switch result {
        case "exceedingly hard":
            return "What are your doing?! Your semester is exceedingly hard."
        case "very hard":
            return "Goodbye social life. Your semester is very hard."
        case "hard":
            return "Be careful! Your semester is hard."
        case "normal":
            return "Yes! Your semester is normal."
        case "easy":
            return "Awesome! Your semester is easy."
        default:
            return "Not enough data to analyze your semester difficulty."
        }*/
        
        return result.uppercased()
    }
    
    class func getDifficultyText(factor: Float, with description: Bool) -> String{
        
        
        switch factor {
        case 1 ..< 1.5:
            return description ?  "💅 Very Easy" : "💅"
        case 1.5 ..< 2:
            return description ?  "☺️ Chill" : "☺️"
        case 2 ..< 2.5:
            return description ?  "✅ Easy" : "✅"
        case 2.5 ..< 3:
            return description ?  "🤔 Not so easy" : "💅"
        case 3 ..< 3.5:
            return description ? "⚪️ Normal" : "⚪️"
        case 3.5 ..< 4:
            return description ? "😯 Careful" : "😯"
        case 4 ..< 4.5:
            return description ? "⚠️ Hard" : "⚠️"
        case 4.5 ... 5:
            return description ? "🔴 Very Hard": "🔴"
        default:
            return "No Data"
        }
    }

    
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    // MARK: - Core Data
    
    class func getCoreDataEntities(entityName: String) -> NSArray{
        
        let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        //var results:NSArray = context.executeFetchRequest(request, error: nil)! as NSArray
        do{
            let results = try context.fetch(request) as NSArray
            
            return results as NSArray
            
        }
            
        catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
            
            return [error.localizedDescription]
        }
        
        
    }
    
    class func removeSavedCourse(id: Int16, savedCourses: inout [CourseData]){
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CourseData")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", (id))
            var objects: [CourseData]
            try objects = managedContext.fetch(fetchRequest) as! [CourseData]
            
            let object = objects.first!
            managedContext.delete(object)
            
            savedCourses.remove(at: Int(id))
            
            //4
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch {
            
        }

    }
    
    class func getSavedCoursesEntities() -> NSArray{
        
        //load savedAreas
        //1
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CourseData")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [ sortDescriptor ]
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            return results as! [CourseData] as NSArray
           
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
        
    }
    
    class func isCourseSaved(sigla: String) -> Bool{
        
        for course in getSavedCoursesEntities(){
            
            if (course as! CourseData).sigla == sigla{
                return true
            }
            
        }
        
        return false
    }
    
    // MARK: - Network
    
    class func startActivityIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    class func stopActivityIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
