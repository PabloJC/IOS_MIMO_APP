//
//  Ingredient+CoreDataProperties.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 15/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ingredient {

    @NSManaged var name: String?
    @NSManaged var category: String?
    @NSManaged var frozen: NSNumber?
    @NSManaged var ingredientID: NSNumber?
    @NSManaged var baseType: String?
    @NSManaged var photo: String?
    @NSManaged var ingredientRecipe: NSSet?
    @NSManaged var store: NSSet?

}
