//
//  Key.swift
//  treep
//
//  Created by Andre Simon on 12/21/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import Foundation
import CoreData


@objc(Key)
class Key: NSManagedObject {
    
    @NSManaged var name: String
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
}
