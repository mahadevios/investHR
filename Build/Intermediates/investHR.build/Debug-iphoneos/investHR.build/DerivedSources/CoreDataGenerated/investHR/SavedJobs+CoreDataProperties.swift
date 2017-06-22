//
//  SavedJobs+CoreDataProperties.swift
//  
//
//  Created by mac on 22/06/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SavedJobs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedJobs> {
        return NSFetchRequest<SavedJobs>(entityName: "SavedJobs");
    }

    @NSManaged public var domainType: String?
    @NSManaged public var jobId: String?
    @NSManaged public var userId: String?

}
