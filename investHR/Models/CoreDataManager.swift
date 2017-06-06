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
    static let managedObjectContext = AppDelegate().getManageObjectContext()
    
    private override init()
    {
        //managedObjectContext = AppDelegate().getManageObjectContext()
    }
    
//    class func getSharedCoreDataManager() -> CoreDataManager
//    {
//        return sharedManager;
//    }
    
    func save(entity: String, _ attributes: [String: Any]) -> NSManagedObject?
    {
        //let sharedManager = CoreDataManager.sharedManager // to initialize managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: entity, in: CoreDataManager.managedObjectContext)
        let object = NSManagedObject(entity: entity!, insertInto: CoreDataManager.managedObjectContext)
        
        for (key, attr) in attributes {
            object.setValue(attr, forKey: key)
        }
        
        do
        {
            try CoreDataManager.managedObjectContext.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return object
    }
    
    func fetch(entity: String) -> [NSManagedObject]?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let manageObjects = try CoreDataManager.managedObjectContext.fetch(fetchRequest)

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
            CoreDataManager.managedObjectContext.delete(data![index])
            
            data!.remove(at: index)
            
            do
            {
                try CoreDataManager.managedObjectContext.save()
                
            } catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            return true
        }
        
        return false
    }
    
    func deleteAllRecords(entity:String) -> Void
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: CoreDataManager.managedObjectContext)
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let results = try CoreDataManager.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
                for result in results!
                {
                    CoreDataManager.managedObjectContext.delete(result)
                }
            
        }
        catch let error as NSError
        {
         print(error.localizedDescription)
        }
            
        do
        {
            try CoreDataManager.managedObjectContext.save()
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }

    
    }
    func idExists (aToken:String,  entityName:String) -> Bool
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let predicate = NSPredicate(format: "userId == %@", argumentArray: [aToken])
        
        request.predicate = predicate
        
        
        do
        {
            let count = try CoreDataManager.managedObjectContext.count(for: request)
            
            if count == 0 {
                return false
            }
        }
        catch let error as NSError
        {
          print(error.localizedDescription)
        }
        
        return true
    }
}
