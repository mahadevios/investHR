//
//  CoreDataManager.swift
//  investHR
//
//  Created by mac on 16/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit
import CoreData


class CoreDataManager: NSObject
{
    static let sharedManager = CoreDataManager()
    var managedObjectContext:NSManagedObjectContext
    
    private override init()
    {
        managedObjectContext = AppDelegate().getManageObjectContext()
    }
    
    class func getSharedCoreDataManager() -> CoreDataManager
    {
        return sharedManager;
    }
    
    func save(entity: String, _ attributes: [String: Any]) -> NSManagedObject?
    {
        
        var entity = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        let object = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        
        for (key, attr) in attributes {
            object.setValue(attr, forKey: key)
        }
        
        do
        {
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return object
    }
    
    func fetch(entity: String) -> [NSManagedObject]?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let manageObjects = try managedObjectContext.fetch(fetchRequest)

                if manageObjects.count > 0
                {
                    return manageObjects as? [NSManagedObject]
                }
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }
//        if let entities = managedObjectContext.fetch(request) as? [NSManagedObject]
//        {
//            if entities.count > 0
//            {
//                return entities
//            }
//        }
        return nil
    }
    
    func delete(entity: String, index: Int) -> Bool
    {
        var data = fetch(entity: entity)
        if data != nil
        {
            managedObjectContext.delete(data![index])
            
            data!.remove(at: index)
            
            do
            {
                try managedObjectContext.save()
                
            } catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            return true
        }
        
        return false
    }
}
