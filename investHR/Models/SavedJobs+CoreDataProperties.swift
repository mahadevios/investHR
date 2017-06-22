//
//  SavedJobs+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 22/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension SavedJobs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedJobs> {
        return NSFetchRequest<SavedJobs>(entityName: "SavedJobs");
    }

    @NSManaged public var userId: String?
    @NSManaged public var jobId: String?
    @NSManaged public var domainType: String?

}
