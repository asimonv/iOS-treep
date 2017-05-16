//
//  CourseData.swift
//  treep
//
//  Created by Andre Simon on 12/31/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import Foundation
import CoreData

@objc(CourseData)
class CourseData: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var sigla: String
    @NSManaged var id: Int16
    @NSManaged var parentList: UserCoursesList?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
}
