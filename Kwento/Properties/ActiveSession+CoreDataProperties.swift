//
//  ActiveSession+CoreDataProperties.swift
//  
//
//  Created by Art John on 23/01/2020.
//
//

import Foundation
import CoreData


extension ActiveSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveSession> {
        return NSFetchRequest<ActiveSession>(entityName: "ActiveSession")
    }

    @NSManaged public var id: String?

}
