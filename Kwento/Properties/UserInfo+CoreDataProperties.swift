//
//  UserInfo+CoreDataProperties.swift
//  Kwento
//
//  Created by Art John on 11/02/2020.
//  Copyright © 2020 Richtone Hangad. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var access_token: String?
    @NSManaged public var client_id: String?
    @NSManaged public var expires: String?
    @NSManaged public var expires_in: String?
    @NSManaged public var issued: String?
    @NSManaged public var password: String?
    @NSManaged public var refresh_token: String?
    @NSManaged public var token_type: String?
    @NSManaged public var userName: String?

}
