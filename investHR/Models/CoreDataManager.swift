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
    private static let sharedCoreDataManager = CoreDataManager()
    //private var dummyObject:APIManager
    
    private override init()
    {
        super.init()
        // dummyObject = APIManager()
    }
    
    class func getSharedCoreDataManager() -> CoreDataManager
    {
        return sharedCoreDataManager;
    }

    
//    class func getSharedCoreDataManager() -> CoreDataManager
//    {
//        return sharedManager;
//    }
    
    func save(entity: String, _ attributes: [String: Any]) -> NSManagedObject?
    {
        //let sharedManager = CoreDataManager.sharedManager // to initialize managedObjectContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let entity = NSEntityDescription.entity(forEntityName: entity, in: appDelegate.managedObjectContext)
        let object = NSManagedObject(entity: entity!, insertInto: appDelegate.managedObjectContext)
        
        for (key, attr) in attributes {
            object.setValue(attr, forKey: key)
        }
        
        do
        {
            try appDelegate.managedObjectContext.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return object
    }
    
    func fetch(entity: String) -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)

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
    
    func fetchCitiesFromStateId(entity: String, stateId:Int16) -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        print(stateId)
        fetchRequest.predicate = NSPredicate(format: "stateId == %d", stateId)

        do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        var data = fetch(entity: entity)
        if data != nil
        {
            appDelegate.managedObjectContext.delete(data![index])
            
            data!.remove(at: index)
            
            do
            {
                try appDelegate.managedObjectContext.save()
                
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: appDelegate.managedObjectContext)
        fetchRequest.includesPropertyValues = false
        
        do
        {
            let results = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            
                for result in results!
                {
                    appDelegate.managedObjectContext.delete(result)
                }
            
        }
        catch let error as NSError
        {
         print(error.localizedDescription)
        }
            
        do
        {
            try appDelegate.managedObjectContext.save()
            
        } catch let error as NSError
        {
            print(error.localizedDescription)
        }

    
    }
    func idExists (aToken:String,  entityName:String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let predicate = NSPredicate(format: "userId == %@", argumentArray: [aToken])
        
        request.predicate = predicate
        
        
        do
        {
            let count = try appDelegate.managedObjectContext.count(for: request)
            
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
