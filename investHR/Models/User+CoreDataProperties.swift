//
//  User+CoreDataProperties.swift
//  
//
//  Created by mac on 05/06/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var occupation: String?
    @NSManaged public var pictureUrl: String?
    @NSManaged public var userId: String?
    @NSManaged public var emailAddress: String?


}
