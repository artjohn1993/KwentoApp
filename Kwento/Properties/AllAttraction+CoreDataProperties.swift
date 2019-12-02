//
//  AllAttraction+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 01/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension AllAttraction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllAttraction> {
        return NSFetchRequest<AllAttraction>(entityName: "AllAttraction")
    }

    @NSManaged public var id: String?
    @NSManaged public var sub_attractions: Bool
    @NSManaged public var attraction_type_id: String?
    @NSManaged public var name: String?
    @NSManaged public var city_id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var location_info: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var image_filename: String?
    @NSManaged public var audio_filename: String?

}
