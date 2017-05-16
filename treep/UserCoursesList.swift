//
//  UserCoursesList.swift
//  treep
//
//  Created by Andre Simon on 12/31/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import Foundation
import CoreData

@objc(UserCoursesList)
class UserCoursesList: NSManagedObject {
    
    @NSManaged var userCourses: NSMutableOrderedSet?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    //MARK: - Initialize
    convenience init(needSave: Bool,  context: NSManagedObjectContext?) {
        
        // Create the NSEntityDescription
        let entity = NSEntityDescription.entity(forEntityName: "UserCoursesList", in: context!)
        
        if(!needSave) {
            self.init(entity: entity!, insertInto: nil)
        } else {
            self.init(entity: entity!, insertInto: context)
        }
        
        // Init class variables
        
    }
    
}

