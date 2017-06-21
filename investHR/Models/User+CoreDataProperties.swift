//
//  User+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 21/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var emailAddress: String?
    @NSManaged public var name: String?
    @NSManaged public var occupation: String?
    @NSManaged public var pictureUrl: String?
    @NSManaged public var userId: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var linkedInId: String?

}
