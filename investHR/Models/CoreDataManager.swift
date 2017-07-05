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
    
    func getAllRecords(entity: String) -> [NSManagedObject]?
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

        var data = getAllRecords(entity: entity)
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
        
        var predicate:NSPredicate!
        if entityName == "CommonNotification"
        {
            predicate = NSPredicate(format: "jobId == %d", argumentArray: [Int(aToken)!])

        }
        else
        {
            predicate = NSPredicate(format: "userId == %@", argumentArray: [aToken])
        }
        
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
    
    func getMaxUserId(entityName:String) -> String
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        
        fetchRequest.fetchLimit = 1
        
        //let predicate = NSPredicate(format: "userId == %@", argumentArray: [aToken])

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userId", ascending: false)]
        
        do
        {
            let user = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [User]
            let max = user.first
            
            guard let userId = max?.value(forKey: "userId") as? String else
            {
                return "0"
            }
            //print(max?.value(forKey: "userId"))
            return userId
            
            
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        return "0"
    }
    
    func checkUserAlreadyExistWithEmail(email:String?, linkledInId:String?) -> Bool
    {
        var predicate:NSPredicate!
        if let emailId = email, let linkedIn = linkledInId
        {
            predicate = NSPredicate(format: "emailAddress == %@ OR linkedInId == %@", argumentArray: [emailId,linkedIn])
        }
        else
        if let emailId = email
        {
            predicate = NSPredicate(format: "email == %@", argumentArray: [emailId])

//            predicate = NSPredicate(format: "email == %@ OR linkedInId == %@", argumentArray: [email,linkledInId])
        }
        else
        if let linkledInId = linkledInId
        {
            predicate = NSPredicate(format: "linkledInId == %@", argumentArray: [linkledInId])
                
                //            predicate = NSPredicate(format: "email == %@ OR linkedInId == %@", argumentArray: [email,linkledInId])
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        
        //let predicate1 = NSPredicate(format: "linkedInId == %@", argumentArray: [linkledInId])

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
    
    func updateUser(pictureUrl: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do
        {
            if let fetchResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    var managedObject = fetchResults[0]
                    managedObject.setValue(pictureUrl, forKey: "pictureUrl")
                    
                    try appDelegate.managedObjectContext.save()
                        
                    
                }
            }
 
            
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }

}
