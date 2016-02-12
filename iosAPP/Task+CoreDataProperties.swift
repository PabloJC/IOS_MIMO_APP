//
//  Task+CoreDataProperties.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 3/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var seconds: NSNumber?
    @NSManaged var taskDescription: String?
    @NSManaged var taskID: NSNumber?
    @NSManaged var recipes: Recipe?

}
