//
//  Recipe+CoreDataProperties.swift
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

extension Recipe {

    @NSManaged var author: String?
    @NSManaged var dificulty: NSNumber?
    @NSManaged var favorite: NSNumber?
    @NSManaged var name: String?
    @NSManaged var portions: NSNumber?
    @NSManaged var score: NSNumber?
    @NSManaged var recipeID: NSNumber?
    @NSManaged var photo: String?
    @NSManaged var ingredientsRecipe: NSSet?
    @NSManaged var tasks: NSSet?

}
