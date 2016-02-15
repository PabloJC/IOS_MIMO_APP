//
//  IngredientTask+CoreDataProperties.swift
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

extension IngredientTask {

    @NSManaged var ingredientTaskID: NSNumber?
    @NSManaged var measure: String?
    @NSManaged var quantity: NSNumber?
    @NSManaged var ingredient: Ingredient?
    @NSManaged var recipe: Recipe?

}
