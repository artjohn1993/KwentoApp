//
//  AttractionByCity+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 28/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension AttractionByCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttractionByCity> {
        return NSFetchRequest<AttractionByCity>(entityName: "AttractionByCity")
    }

    @NSManaged public var title: String?
    @NSManaged public var total: String?
    @NSManaged public var image: String?

}
