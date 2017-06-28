//
//  FTPImageUpload.swift
//  investHR
//
//  Created by mac on 22/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation


class FTPImageUpload
{
    fileprivate let ftpBaseUrl: String
    fileprivate let directoryPath: String
    fileprivate let username: String
    fileprivate let password: String
    
    init(baseUrl: String, userName: String, password: String, directoryPath: String)
    {
//        self.ftpBaseUrl = "ftp.mtcommunicator.com"
//        self.username = "mt@mtcommunicator.com"
//        self.password = "mtone@123"
//        self.directoryPath = "TEST"
        
        self.ftpBaseUrl = baseUrl
        self.username = userName
        self.password = password
        self.directoryPath = directoryPath
    }
}


// MARK: Steam Setup

extension FTPImageUpload
{
    private func setFtpUserName(for ftpWriteStream: CFWriteStream, userName: String)
    {
        CFWriteStreamSetProperty(ftpWriteStream, CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPUserName), userName as CFString)
    }
    
    private func setFtpPassword(for ftpWriteStream: CFWriteStream, password: String)
    {
        CFWriteStreamSetProperty(ftpWriteStream, CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPPassword), password as CFString)
    }
    
    fileprivate func ftpWriteStream(forFileName fileName: String) -> CFWriteStream?
    {
        let fullyQualifiedPath = "ftp://\(self.ftpBaseUrl)/\(self.directoryPath)/\(fileName)" as CFString
        guard let ftpUrl = CFURLCreateWithString(kCFAllocatorDefault, fullyQualifiedPath, nil) else { return nil }
        let ftpStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorDefault, ftpUrl)
        let ftpWriteStream = ftpStream.takeRetainedValue()
//        setFtpUserName(for: ftpWriteStream, userName: "mt@mtcommunicator.com")
//        setFtpPassword(for: ftpWriteStream, password: "mtone@123")
        setFtpUserName(for: ftpWriteStream, userName: self.username)
        setFtpPassword(for: ftpWriteStream, password: self.password)
        return ftpWriteStream
    }
}


// MARK: FTP Write

extension FTPImageUpload
{
    func send(data: Data, with fileName: String) -> Bool
    {
        
      if AppPreferences.sharedPreferences().isReachable
      {
        
        guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else { return false }
        
        if CFWriteStreamOpen(ftpWriteStream) == false {
            print("Could not open stream")
            return false
        }
        
        defer { CFWriteStreamClose(ftpWriteStream) }
        
        let fileSize = data.count
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
        data.copyBytes(to: buffer, count: fileSize)
        
        var offset = 0
        var dataToSendSize = fileSize
        //DispatchQueue.main.async(execute: {

        
        
            //DispatchQueue.main.async(execute: {

                
                //DispatchQueue.global().async {
        
                    repeat {
                        
                            let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
                        
                        
                            if bytesWritten > 0 {
                                offset += bytesWritten.littleEndian
                                dataToSendSize -= bytesWritten
                                continue
                            } else if bytesWritten < 0 {
                                // ERROR
                                print("ERROR ERROR ERROR")
                                break
                            } else if bytesWritten == 0 {
                                // SUCCESS
                                print("Completed!!")
                                break
                            }
                        
                        
                    } while CFWriteStreamCanAcceptBytes(ftpWriteStream)
                    
        
                //}
           // })
        
        
        
        
        //})
        
        
        return true
    
        }
        
        else
        {
            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
            
            return false
        }
    }
}
