//
//  Ingredients+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Jadson on 24/07/22.
//
//

import Foundation
import CoreData


extension Ingredients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredients> {
        return NSFetchRequest<Ingredients>(entityName: "Ingredients")
    }

    @NSManaged public var ingredientName: String?
    @NSManaged public var canEdit: Bool
    @NSManaged public var recipe: NSSet?
    @NSManaged public var image: Image?

}

// MARK: Generated accessors for recipe
extension Ingredients {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: Recipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: Recipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}

extension Ingredients : Identifiable {

}
