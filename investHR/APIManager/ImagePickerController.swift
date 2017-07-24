//
//  ImagePickerController.swift
//  investHR
//
//  Created by mac on 24/07/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation

class ImagePickerController: UIImagePickerController
{
    private static let sharedPickerController = ImagePickerController()
    //private var dummyObject:APIManager
    
//    private override init()
//    {
//       // super.init()
//        // dummyObject = APIManager()
//    }
    
    class func getSharedPickerController() -> ImagePickerController
    {
        return sharedPickerController;
    }

}
