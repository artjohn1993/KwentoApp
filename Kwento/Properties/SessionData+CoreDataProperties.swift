//
//  SessionData+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 02/12/2019.
//  Copyright © 2019 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension SessionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionData> {
        return NSFetchRequest<SessionData>(entityName: "SessionData")
    }

    @NSManaged public var attraction: String?
    @NSManaged public var attraction_id: String?
    @NSManaged public var end_date: String?
    @NSManaged public var id: String?
    @NSManaged public var start_date: String?
    @NSManaged public var user_id: String?

}
