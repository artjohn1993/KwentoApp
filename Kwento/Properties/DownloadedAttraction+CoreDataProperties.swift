//
//  DownloadedAttraction+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 26/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension DownloadedAttraction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadedAttraction> {
        return NSFetchRequest<DownloadedAttraction>(entityName: "DownloadedAttraction")
    }

    @NSManaged public var attractionDescription: String?
    @NSManaged public var attractionTypeId: String?
    @NSManaged public var audioFilename: String?
    @NSManaged public var cityId: Int16
    @NSManaged public var id: String?
    @NSManaged public var imageFilename: String?
    @NSManaged public var latitude: Float
    @NSManaged public var locationInfo: String?
    @NSManaged public var longitude: Float
    @NSManaged public var name: String?
    @NSManaged public var qrCodeFilename: String?

}
