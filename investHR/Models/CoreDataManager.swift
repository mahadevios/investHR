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
        
        for (key, attr) in attributes
        {
            object.setValue(attr, forKey: key)
            
        }
        
        do
        {
            try appDelegate.managedObjectContext.save()
            
        } catch let error as NSError {
            //////print(error.localizedDescription)
        }
        
        return object
    }
    
    func getAllRecords(entity: String) -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        

        if entity == "CommonNotification"
        {
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String

            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "notificationDate1", ascending: false)]
            
            fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
            
        }
        else
        if entity == "User"
        {
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String

            fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)

        }
        do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)

                if manageObjects.count > 0
                {
                    return manageObjects as? [NSManagedObject]
                }
        } catch let error as NSError
        {
            ////print(error.localizedDescription)
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
    
    func getAllRecordsOfNotification(notificationType: String) -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommonNotification")
        
        
       
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "notificationDate1", ascending: false)]
            
            fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
            
            let  predicate = NSPredicate(format: "userId == %@ AND notificationType == %@", argumentArray: [userId,notificationType])
        
            fetchRequest.predicate = predicate
        
        do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
            if manageObjects.count > 0
            {
                return manageObjects as? [NSManagedObject]
            }
        } catch let error as NSError
        {
            //print(error.localizedDescription)
        }
        return nil
    }
   

    func getAllRecordsOfSpecialNotification() -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ZSpecialNotification")
        
        
        
        let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "notificationDate", ascending: false)]
        
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        
        let  predicate = NSPredicate(format: "userId == %@", argumentArray: [userId])
        
        fetchRequest.predicate = predicate
        
        do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
            if manageObjects.count > 0
            {
                return manageObjects as? [NSManagedObject]
            }
        } catch let error as NSError
        {
            //print(error.localizedDescription)
        }
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
            //print(error.localizedDescription)
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
                //print(error.localizedDescription)
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
         //print(error.localizedDescription)
        }
            
        do
        {
            try appDelegate.managedObjectContext.save()
            
        } catch let error as NSError
        {
            //print(error.localizedDescription)
        }

    
    }
    
    func getNotiRecordsTodelete(entity: String, date:String) -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        
        
            //let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
              //  let date = Date()
        //
                //let dateToDelete = date.addingTimeInterval(-2*24*60*60)
        
            fetchRequest.predicate = NSPredicate(format: "notificationDate1 < %@", date as CVarArg)
            
            do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
            if manageObjects.count > 0
            {
                return manageObjects as? [NSManagedObject]
            }
        } catch let error as NSError
        {
            //print(error.localizedDescription)
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

    func deleteOldNotifications(entity: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
//        let date = Date()
//        
//        let dateToDelete = date.addingTimeInterval(-10*24*60*60)
        
        
        
        var dayComponent = DateComponents()
        dayComponent.day = 0
        
        let theCalendar = Calendar.current
        //    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
//        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        let formatter = DateFormatter()
        
        let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
        
        //NSLog(@"nextDate: %@ ...", nextDate);
        // NSDate *purgeDataDate = [[NSDate date] dateByAddingTimeInterval:-5*24*60*60];
        
        
        formatter.dateFormat = "MM-dd-yyyy"
        
        let newDate = formatter.string(from: nextDate!)
        
        let notifObj = getNotiRecordsTodelete(entity: "CommonNotification", date:newDate) as? [CommonNotification]

        //NSString *query3=[NSString stringWithFormat:@"Select RecordItemName,TransferDate from CubeData Where TransferStatus = 1 and DeleteStatus = 0 and TransferDate < '%@'",newDate];

        if notifObj != nil
        {
            //appDelegate.managedObjectContext.delete(data![index])
            
            //data!.remove(at: index)
            
            for obj in notifObj!
            {
                appDelegate.managedObjectContext.delete(obj)
            }
            do
            {
                
                try appDelegate.managedObjectContext.save()
                
            } catch let error as NSError
            {
                //print(error.localizedDescription)
            }
            
            return true
        }
        
        return false
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
        if entityName == "ZSpecialNotification"
        {
            predicate = NSPredicate(format: "notificationId1 == %d", argumentArray: [Int(aToken)!])
            
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
            else
            {
                return true
            }
        }
        catch let error as NSError
        {
          //print(error.localizedDescription)
        }
        
        return false
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
            //print(error.localizedDescription)
        }
        return "0"
    }
    
    func getUserId(email:String?, linkledInId:String?) -> Int
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var predicate:NSPredicate!
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

        if let emailId = email, let linkedIn = linkledInId
        {
            predicate = NSPredicate(format: "emailAddress == %@ AND linkedInId == %@", argumentArray: [emailId,linkedIn])
            fetchRequest.predicate = predicate
        }
        else
            if let emailId = email
            {
                predicate = NSPredicate(format: "email == %@", argumentArray: [emailId])
                fetchRequest.predicate = predicate

                //            predicate = NSPredicate(format: "email == %@ OR linkedInId == %@", argumentArray: [email,linkledInId])
            }
            else
                if let linkledInId = linkledInId
                {
                    predicate = NSPredicate(format: "linkledInId == %@", argumentArray: [linkledInId])
                    fetchRequest.predicate = predicate

                    //            predicate = NSPredicate(format: "email == %@ OR linkedInId == %@", argumentArray: [email,linkledInId])
        }

        
        
        //fetchRequest.fetchLimit = 1
        
        //let predicate = NSPredicate(format: "userId == %@", argumentArray: [aToken])
        
        
        do
        {
            let user = try appDelegate.managedObjectContext.fetch(fetchRequest) as! [User]
            
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
            if manageObjects.count > 0
            {
               // return (manageObjects as? [NSManagedObject])!
                let user = manageObjects[0] as! User
                
                return Int(user.userId!)!
            }
            
            
        }
        catch let error as NSError
        {
            //print(error.localizedDescription)
        }
        return 0
    }
    
    func checkUserAlreadyExistWithEmail(email:String?, linkledInId:String?) -> Bool
    {
        var predicate:NSPredicate!
        if let emailId = email, let linkedIn = linkledInId
        {
            predicate = NSPredicate(format: "emailAddress == %@ AND linkedInId == %@", argumentArray: [emailId,linkedIn])
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
            //print(error.localizedDescription)
        }
        
        return true
    }
    
    func checkUserAlreadyExistWithUserId(userId:String?) -> Bool
    {
        var predicate:NSPredicate!
        
        predicate = NSPredicate(format: "userId == %@", argumentArray: [userId!])
                    
                    //            predicate = NSPredicate(format: "email == %@ OR linkedInId == %@", argumentArray: [email,linkledInId])
        
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
            //print(error.localizedDescription)
        }
        
        return true
    }

    func updateUser(pictureUrl: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
        
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
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
            //print(error.localizedDescription)
        }
        
    }
    
    func deleteUserVideos(entity:String, videoName:String)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: appDelegate.managedObjectContext)

        let predicate = NSPredicate(format: "videoName == %@", argumentArray: [videoName])
        
        fetchRequest.predicate = predicate

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
            //print(error.localizedDescription)
        }
        
        do
        {
            try appDelegate.managedObjectContext.save()
            
        } catch let error as NSError
        {
            //print(error.localizedDescription)
        }
        
        
    }
    func updateNotificationJob(entityName:String, jobId:Int, subject:String, notificationDate:String!, userId:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext = appDelegate.managedObjectContext
        var predicate:NSPredicate!

        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        predicate = NSPredicate(format: "jobId == %d", argumentArray: [Int(jobId)])
        fetchRequest.predicate = predicate
        do
        {
            if let fetchResults = try appDelegate.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    var managedObject = fetchResults[0]
                    managedObject.setValue(subject, forKey: "subject")
                    managedObject.setValue(notificationDate, forKey: "notificationDate1")

                    try appDelegate.managedObjectContext.save()
                    
                    
                }
            }
            
            
        }
        catch let error as NSError
        {
            //print(error.localizedDescription)
        }

    }

    
    func getRecordedVideoNames(entity: String, userId: String) -> [NSManagedObject]?
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            
            return nil
        }
        var predicate:NSPredicate!
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        predicate = NSPredicate(format: "userId == %@", argumentArray: [userId])
        fetchRequest.predicate = predicate

        
        do {
            let manageObjects = try appDelegate.managedObjectContext.fetch(fetchRequest)
            
            if manageObjects.count > 0
            {
                return manageObjects as? [NSManagedObject]
            }
        } catch let error as NSError
        {
            //print(error.localizedDescription)
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

}
