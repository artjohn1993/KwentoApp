//
//  Attraction+CoreDataProperties.swift
//  
//
//  Created by Art John on 26/11/2019.
//
//

import Foundation
import CoreData


extension Attraction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attraction> {
        return NSFetchRequest<Attraction>(entityName: "Attraction")
    }

    @NSManaged public var qrCodeFilename: String?
    @NSManaged public var id: String?
    @NSManaged public var attractionTypeId: String?
    @NSManaged public var name: String?
    @NSManaged public var cityId: Int16
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var locationInfo: String?
    @NSManaged public var attractionDescription: String?
    @NSManaged public var imageFilename: String?
    @NSManaged public var audioFilename: String?

}
