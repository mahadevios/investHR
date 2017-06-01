//
//  APIManager.swift
//  investHR
//
//  Created by mac on 31/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class APIManager: NSObject
{
    private static let sharedManager = APIManager()
    //private var dummyObject:APIManager
    
    private override init()
    {
        super.init()
       // dummyObject = APIManager()
    }
    
    class func getSharedAPIManager() -> APIManager
    {
        return sharedManager;
    }

}
