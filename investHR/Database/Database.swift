//
//  Database.swift
//  investHR
//
//  Created by mac on 20/09/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation


public class Database:NSObject
{
    private static let sharedDatabase = Database()
    //private var dummyObject:APIManager
    
    private override init()
    {
        super.init()
        // dummyObject = APIManager()
    }
    
    class func sharedDatabse() -> Database
    {
        return sharedDatabase;
    }

    func db()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("investHR.sqlite")
        
        // open database
        
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            //print("error opening database")
        }
    }
    
    func getDatabasePath() ->URL
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("investHR.sqlite")
        
        return fileURL
    }
    
    func openDatabase(fileUrl:URL) -> OpaquePointer?
    {
        var db: OpaquePointer?
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK
        {
            //print("error opening database")
            return nil
        }
        else
        {
            return db!
        }
    }
    
    func insertIntoUser(user:User1)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        

        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?

//            let query = "insert into ZUSER (ZEMAILADDRESS, ZLINKEDINID, ZNAME, ZOCCUPATION, ZPASSWORD, ZPICTUREURL, ZUSERID, ZUSERNAME) values (\(String(describing: "sa")),\(String(describing: user.linkedInId!)),\(String(describing: user.name!)),\(String(describing: user.occupation!)),\(String(describing: user.password!)),\(String(describing: user.pictureUrl!)),\(String(describing: user.userId!)),\(String(describing: "")))"
            //EMAILADDRESS VARCHAR, LINKEDINID VARCHAR, NAME VARCHAR, OCCUPATION VARCHAR, PASSWORD VARCHAR, PICTUREURL VARCHAR, USERID VARCHAR PRIMARY KEY , USERNAME VARCHAR
            let query = "insert or replace into USER (EMAILADDRESS, LINKEDINID, NAME, OCCUPATION, PASSWORD, PICTUREURL, USERID, USERNAME) values (?,?,?,?,?,?,?,?)"
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(String(describing: user.emailAddress!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2, "\(String(describing: user.linkedInId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 3, "\(String(describing: user.name!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 4, "\(String(describing: user.occupation!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 5, "\(String(describing: user.password!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 6, "\(String(describing: user.pictureUrl!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 7, "\(String(describing: user.userId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }

            if sqlite3_bind_text(statement, 8, "\(String(describing: user.username!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding foo: \(errmsg)")
            }

            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting foo: \(errmsg)")
            }
            else
            {
              //print("inserted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }

        }
    }
    
    func insertIntoSavedJobs(job:Job)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            
            let query = "insert into ZSAVEDJOBS (ZJOBID, ZUSERID) values (?,?)"
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(String(describing: job.jobId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2, "\(String(describing: job.userId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                //print("inserted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
        }
    }

    
    func insertIntoAppliedJobs(job:Job)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            
            let query = "insert into ZAPPLIEDJOBS (ZJOBID, ZUSERID) values (?,?)"
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(String(describing: job.jobId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2, "\(String(describing: job.userId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                //print("inserted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
    }
    
    func truncateTable(tableName:String)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            
            let query = "delete from \(tableName) where ZJOBID > 0"
            
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                print("deleted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }

    }

    func deleteOldNotification(tableName:String)
    {
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        var dayComponent = DateComponents()
        
        //dayComponent.day = 1
        dayComponent.day = -9

        //dayComponent.day = 2
        
        let theCalendar = Calendar.current
        
        let formatter = DateFormatter()
        
        let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
        
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        let newDate = formatter.string(from: nextDate!)

        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            var query = ""
            
            query = "delete from \(tableName) where NOTIFICATIONDATE < ?"

            
            
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 1, "\(String(describing: newDate))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                print("deleted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
        
    }

    func getUserData() -> User1
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        let user = User1()

        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String

            if sqlite3_prepare_v2(db, "select * from USER where USERID = \(userId)", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            

            while sqlite3_step(statement) == SQLITE_ROW
            {
                //EMAILADDRESS VARCHAR, LINKEDINID VARCHAR, NAME VARCHAR, OCCUPATION VARCHAR, PASSWORD VARCHAR, PICTUREURL VARCHAR, USERID VARCHAR PRIMARY KEY , USERNAME VARCHAR
                
                if let cString = sqlite3_column_text(statement, 0)
                {
                    let email = String(cString: cString)
                    user.emailAddress = email
                    print("name = \(email)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 1)
                {
                    let linkedInId = String(cString: cString)
                    user.linkedInId = linkedInId
                    print("name = \(linkedInId)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 2)
                {
                    let name = String(cString: cString)
                    user.name = name
                    print("name = \(name)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 4)
                {
                    let password = String(cString: cString)
                    user.password = password
                    print("password = \(password)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 5)
                {
                    let pictureUrl = String(cString: cString)
                    user.pictureUrl = pictureUrl
                    print("pictureUrl = \(pictureUrl)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 6)
                {
                    let userId = String(cString: cString)
                    user.userId = userId
                    print("userId = \(userId)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 7)
                {
                    let username = String(cString: cString)
                    user.username = username
                    print("username = \(username)")
                }
                else
                {
                    //print("name not found")
                }
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }
            
        }
        return user

    }

    
    
    func getJobsNotification() -> [JobsNotification]?
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        var jobNotificationObjectsArray = [JobsNotification]()

        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            if sqlite3_prepare_v2(db, "select * from COMMONNOTIFICATION where USERID = \(userId) order by NOTIFICATIONDATE desc", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let jobNotiObj = JobsNotification()

                //JOBID INTEGER PRIMARY KEY ,NOTIFICATIONID INTEGER,NOTIFICATIONDATE VARCHAR DEFAULT (null) ,SUBJECT VARCHAR,USERID VARCHAR,NOTIFICATIONTYPE INTEGER, READSTATUS INTEGER)
                let jobId = sqlite3_column_int64(statement, 0)
                jobNotiObj.jobId = jobId
                
                let notiType = sqlite3_column_int64(statement, 1)
                jobNotiObj.notificationId = Int16(notiType)
                
                let notificationType = sqlite3_column_int64(statement, 5)
                jobNotiObj.notificationType = Int16(notificationType)
                
                let readStatus = sqlite3_column_int64(statement, 6)
                jobNotiObj.readStatus = Int16(readStatus)
                //let notificationDate = sqlite3_column_int64(statement, 3)

                //ZJOBID INTEGER, ZNOTIFICATIONID INTEGER, ZNOTIFICATIONTYPE INTEGER, ZREADSTATUS INTEGER, ZNOTIFICATIONDATE1 VARCHAR, ZSUBJECT VARCHAR, ZUSERID VARCHAR
                if let cString = sqlite3_column_text(statement, 2)
                {
                    let notificationDate = String(cString: cString)
                    jobNotiObj.notificationDate1 = notificationDate
                    print("notificationDate = \(notificationDate)")
                }
                else
                {
//                    print("notificationDate not found")
                }
                
                if let cString = sqlite3_column_text(statement, 3)
                {
                    let subject = String(cString: cString)
                    jobNotiObj.subject = subject
                    print("subject = \(subject)")
                }
                else
                {
//                    print("subject not found")
                }
                
                if let cString = sqlite3_column_text(statement, 4)
                {
                    let userId = String(cString: cString)
                    jobNotiObj.userId = userId
                    print("userId = \(userId)")
                }
                else
                {
//                    print("userId not found")
                }
                
                jobNotificationObjectsArray.append(jobNotiObj)

               
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }

            
        }
                return jobNotificationObjectsArray
        
    }

    
    func getGeneralNotification() -> [GeneralNotification]?
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        var jobNotificationObjectsArray = [GeneralNotification]()
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            if sqlite3_prepare_v2(db, "select * from SPECIALNOTIFICATION where USERID = \(userId) order by NOTIFICATIONDATE desc", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
           // NOTIFICATIONID INTEGER PRIMARY KEY, NOTIFICATIONTYPE INTEGER, NOTIFICATIONDATE VARCHAR, SUBJECT VARCHAR, USERID VARCHAR , READSTATUS INTEGER
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let jobNotiObj = GeneralNotification()
                
                
                let notificationId = sqlite3_column_int64(statement, 0)
                jobNotiObj.notificationId1 = Int16(notificationId)
                
//                let notiType = sqlite3_column_int64(statement, 4)
//                jobNotiObj.notificationId = Int16(notiType)
                
                let notificationType = sqlite3_column_int64(statement, 1)
                jobNotiObj.notificationType = Int16(notificationType)
                
                let readStatus = sqlite3_column_int64(statement, 5)
                jobNotiObj.readStatus = Int16(readStatus)
                //let notificationDate = sqlite3_column_int64(statement, 3)
                
                
                if let cString = sqlite3_column_text(statement, 2)
                {
                    let notificationDate = String(cString: cString)
                    jobNotiObj.notificationDate = notificationDate
                    print("notificationDate = \(notificationDate)")
                }
                else
                {
//                    print("notificationDate not found")
                }
                
                if let cString = sqlite3_column_text(statement, 3)
                {
                    let subject = String(cString: cString)
                    jobNotiObj.subject = subject
                    print("subject = \(subject)")
                }
                else
                {
//                    print("subject not found")
                }
                
                if let cString = sqlite3_column_text(statement, 4)
                {
                    let userId = String(cString: cString)
                    jobNotiObj.userId = userId
                    print("userId = \(userId)")
                }
                else
                {
//                    print("userId not found")
                }
                
                jobNotificationObjectsArray.append(jobNotiObj)
                
                
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }
            
            
        }
        return jobNotificationObjectsArray
        
    }

    
    
    func getUnreadNotiCount(tableName:String) -> Int
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        var count = 0
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            if sqlite3_prepare_v2(db, "select Count(*) from \(tableName) where READSTATUS = 0", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            //ZNOTIFICATIONID1 INTEGER, ZNOTIFICATIONTYPE INTEGER, ZREADSTATUS INTEGER, ZNOTIFICATIONDATE VARCHAR, ZSUBJECT VARCHAR, ZUSERID VARCHAR
            while sqlite3_step(statement) == SQLITE_ROW
            {
                count =  Int(sqlite3_column_int(statement, 0))
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }
            
            
        }
        return count
        
    }

    
    func updateReadStatus(tableName:String, notificationId:Int)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            var query = ""
            
            query = "update \(tableName) set READSTATUS = 1 where NOTIFICATIONID = \(notificationId)"

            
            
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                print("updated successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
        
    }

    
    func insertIntoJobsNotification(notiObj:JobsNotification)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
          // "JOBID" INTEGER PRIMARY KEY ,"NOTIFICATIONID" INTEGER,"NOTIFICATIONDATE" VARCHAR DEFAULT (null) ,"SUBJECT" VARCHAR,"ZUSERID" VARCHAR,"NOTIFICATIONTYPE" INTEGER, READSTATUS INTEGER
            let query = "insert or replace into COMMONNOTIFICATION (JOBID, NOTIFICATIONID, NOTIFICATIONDATE, SUBJECT, USERID, NOTIFICATIONTYPE, READSTATUS) values (?,?,?,?,?,?,?)"
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(String(describing: notiObj.jobId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2, "\(String(describing: notiObj.notificationId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 3, "\(String(describing: notiObj.notificationDate1!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 4, "\(String(describing: notiObj.subject!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 5, "\(String(describing: notiObj.userId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 6, "\(String(describing: notiObj.notificationType!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 7, "\(String(describing: notiObj.readStatus!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                //print("inserted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
    }

    
    func insertIntoGeneralNotification(notiObj:GeneralNotification)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
           // NOTIFICATIONID INTEGER PRIMARY KEY, NOTIFICATIONTYPE INTEGER, NOTIFICATIONDATE VARCHAR, SUBJECT VARCHAR, USERID VARCHAR , "READSTATUS" INTEGER
            let query = "insert into SPECIALNOTIFICATION (NOTIFICATIONID, NOTIFICATIONTYPE, NOTIFICATIONDATE, SUBJECT, USERID, READSTATUS) values (?,?,?,?,?,?)"
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(String(describing: notiObj.notificationId1!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2, "\(String(describing: notiObj.notificationType!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 3, "\(String(describing: notiObj.notificationDate!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 4, "\(String(describing: notiObj.subject!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 5, "\(String(describing: notiObj.userId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 6, "\(String(describing: notiObj.readStatus!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                //print("inserted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
    }

    
    func getRolesVerticalHorizontal(type:String) -> [Role]
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        var roleObjectsArray = [Role]()

        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            //let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            if sqlite3_prepare_v2(db, "select * from \(type)", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            
            while sqlite3_step(statement) == SQLITE_ROW
            {
                //EMAILADDRESS VARCHAR, LINKEDINID VARCHAR, NAME VARCHAR, OCCUPATION VARCHAR, PASSWORD VARCHAR, PICTUREURL VARCHAR, USERID VARCHAR PRIMARY KEY , USERNAME VARCHAR
                let roleObj = Role()

                let roleId = sqlite3_column_int64(statement, 3)
                roleObj.roleId = Int16(roleId)
                
                if let cString = sqlite3_column_text(statement, 4)
                {
                    let roleName = String(cString: cString)
                    roleObj.roleName = roleName
                    print("roleName = \(roleName)")
                }
                else
                {
                    //print("name not found")
                }
                
                roleObjectsArray.append(roleObj)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }
            
        }
        return roleObjectsArray
        
    }
    
    func getSavedJobs(type:String) -> [Job]?
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        var savedObjectsArray = [Job]()
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            //let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            if sqlite3_prepare_v2(db, "select * from \(type)", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            
            while sqlite3_step(statement) == SQLITE_ROW
            {
                //EMAILADDRESS VARCHAR, LINKEDINID VARCHAR, NAME VARCHAR, OCCUPATION VARCHAR, PASSWORD VARCHAR, PICTUREURL VARCHAR, USERID VARCHAR PRIMARY KEY , USERNAME VARCHAR
                let savedJob = Job()
                
                
                
                if let cString = sqlite3_column_text(statement, 4)
                {
                    let roleName = String(cString: cString)
                    savedJob.jobId = roleName
                    //print("roleName = \(roleName)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 5)
                {
                    let roleName = String(cString: cString)
                    savedJob.userId = roleName
                   // print("roleName = \(roleName)")
                }
                else
                {
                    //print("name not found")
                }
                savedObjectsArray.append(savedJob)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }
            
        }
        return savedObjectsArray
    }

    
    func updateUserProfileUrl(profileUrl:String)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            var query = ""
            
            let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String

            query = "update USER set PICTUREURL = ? where USERID = \(userId)"
            
            
            
            let str: String? = String(validatingUTF8: query)
            
            
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 1, "\(profileUrl)", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
                print("updated successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
        
    }
    
    func deleteVideo(videoName:String)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            
            let query = "delete from ZUSERVIDEOS where ZVIDEONAME = ?"
            
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(videoName)", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding jobID: \(errmsg)")
            }
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure inserting Job: \(errmsg)")
            }
            else
            {
//                print("deleted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
            
        }
        
    }


    func insertIntoVideos(videoObj:Videos)
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            
            let query = "insert into ZUSERVIDEOS (ZUSERID, ZVIDEONAME) values (?,?)"
            let str: String? = String(validatingUTF8: query)
            
            if sqlite3_prepare_v2(db, str, -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error preparing insert: \(errmsg)")
            }
            
            if sqlite3_bind_text(statement, 1, "\(String(describing: videoObj.userId!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("failure binding userId: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2, "\(String(describing: videoObj.videoName!))", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding videoname: \(errmsg)")
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting video: \(errmsg)")
            }
            else
            {
                //print("inserted successfully")
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK {
                //print("error closing database")
            }
        }
    }

    
    func getUserVideos(userId:String) -> [Videos]?
    {
        let dbObj = Database.sharedDatabse()
        
        let databasePathUrl =  dbObj.getDatabasePath()
        
        var videoObjectsArray = [Videos]()
        
        
        if let db = dbObj.openDatabase(fileUrl: databasePathUrl)
        {
            var statement: OpaquePointer?
            
            //let userId = UserDefaults.standard.object(forKey: Constant.USERID) as! String
            
            if sqlite3_prepare_v2(db, "select * from ZUSERVIDEOS Where ZUSERID = \(userId)", -1, &statement, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing select: \(errmsg)")
            }
            
            
            while sqlite3_step(statement) == SQLITE_ROW
            {
                //EMAILADDRESS VARCHAR, LINKEDINID VARCHAR, NAME VARCHAR, OCCUPATION VARCHAR, PASSWORD VARCHAR, PICTUREURL VARCHAR, USERID VARCHAR PRIMARY KEY , USERNAME VARCHAR
                let videoObj = Videos()
                
                
                
                if let cString = sqlite3_column_text(statement, 3)
                {
                    let userId = String(cString: cString)
                    videoObj.userId = userId
                    //print("roleName = \(roleName)")
                }
                else
                {
                    //print("name not found")
                }
                
                if let cString = sqlite3_column_text(statement, 4)
                {
                    let videoName = String(cString: cString)
                    videoObj.videoName = videoName
                    // print("roleName = \(roleName)")
                }
                else
                {
                    //print("name not found")
                }
                videoObjectsArray.append(videoObj)
            }
            
            if sqlite3_finalize(statement) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                //print("error finalizing prepared statement: \(errmsg)")
            }
            
            statement = nil
            
            if sqlite3_close(db) != SQLITE_OK
            {
                //print("error closing database")
            }
            
        }
        return videoObjectsArray
    }

}
