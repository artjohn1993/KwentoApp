//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by Art John on 15/11/2019.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var token_type: String?
    @NSManaged public var expires_in: String?
    @NSManaged public var refresh_token: String?
    @NSManaged public var access_token: String?
    @NSManaged public var client_id: String?
    @NSManaged public var userName: String?
    @NSManaged public var issued: String?
    @NSManaged public var expires: String?
    @NSManaged public var password: String?

}
