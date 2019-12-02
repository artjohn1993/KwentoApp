//
//  DownloadedFiles+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 26/11/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension DownloadedFiles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadedFiles> {
        return NSFetchRequest<DownloadedFiles>(entityName: "DownloadedFiles")
    }

    @NSManaged public var image: String?
    @NSManaged public var audio: String?

}
