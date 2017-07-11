//
//  UserVideos+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 11/07/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension UserVideos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserVideos> {
        return NSFetchRequest<UserVideos>(entityName: "UserVideos");
    }

    @NSManaged public var videoName: String?
    @NSManaged public var userId: String?

}
