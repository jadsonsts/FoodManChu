//
//  Image+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Jadson on 6/07/22.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var recipe: Recipe?

}

extension Image : Identifiable {

}
