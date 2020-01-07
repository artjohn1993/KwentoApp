//
//  AttractionByType+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 28/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension AttractionByType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttractionByType> {
        return NSFetchRequest<AttractionByType>(entityName: "AttractionByType")
    }

    @NSManaged public var title: String?
    @NSManaged public var total: String?
    @NSManaged public var image: String?
    @NSManaged public var id: String?

}
