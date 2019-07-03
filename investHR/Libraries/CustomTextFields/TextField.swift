//
//  TextField.swift
//  investHR
//
//  Created by mac on 24/05/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import UIKit

class TextField: UITextField
{
    
    let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
       return bounds.inset(by: padding)
//        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: padding)
//        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: padding)
//        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
