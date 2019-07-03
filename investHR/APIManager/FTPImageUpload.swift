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

//extension FTPImageUpload
//{
//    func send(data: Data, with fileName: String) -> Bool
//    {
//        
//      if AppPreferences.sharedPreferences().isReachable
//      {
//        
//        guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else { return false }
//        
//        if CFWriteStreamOpen(ftpWriteStream) == false {
//            print("Could not open stream")
//            return false
//        }
//        
//        defer { CFWriteStreamClose(ftpWriteStream) }
//        
//        let fileSize = data.count
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
//        data.copyBytes(to: buffer, count: fileSize)
//        
//        var offset = 0
//        var dataToSendSize = fileSize
//        //DispatchQueue.main.async(execute: {
//
//        
//        
//            //DispatchQueue.main.async(execute: {
//
//                
//                //DispatchQueue.global().async {
//        
//                    repeat {
//                        
//                            let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
//                        
//                        
//                            if bytesWritten > 0 {
//                                offset += bytesWritten.littleEndian
//                                dataToSendSize -= bytesWritten
//                                continue
//                            } else if bytesWritten < 0 {
//                                // ERROR
//                                print("ERROR ERROR ERROR")
//                                break
//                            } else if bytesWritten == 0 {
//                                // SUCCESS
//                                print("Completed!!")
//                                break
//                            }
//                        
//                        
//                    } while CFWriteStreamCanAcceptBytes(ftpWriteStream)
//                    
//        
//                //}
//           // })
//        
//        
//        
//        
//        //})
//        
//        
//        return true
//    
//        }
//        
//        else
//        {
//            AppPreferences.sharedPreferences().showAlertViewWith(title: "No internet connection!", withMessage: "Please turn on your inernet connection to access this feature", withCancelText: "Ok")
//            
//            return false
//        }
//    }
//}

extension FTPImageUpload
{
    func send(data: Data, with fileName: String) -> Bool {
        guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else { return false }
        
        if CFWriteStreamOpen(ftpWriteStream) == false {
//            print("Could not open stream")
            return false
        }
        
        defer { CFWriteStreamClose(ftpWriteStream) }
        
        let fileSize = data.count
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
        data.copyBytes(to: buffer, count: fileSize)
        var offset = 0
        var dataToSendSize = fileSize
        
        var bytesWritten = 0
        repeat {
            bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
            if bytesWritten > 0 {
                offset += bytesWritten.littleEndian
                dataToSendSize -= bytesWritten
//                print(bytesWritten)
                continue
            } else if bytesWritten < 0 {
                // ERROR
//                print("ERROR ERROR ERROR")
                break
            } else if bytesWritten == 0 {
                // SUCCESS
//                print("Completed!!")
                break
            }
            
        } while (bytesWritten>0)
//        repeat {
//            let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
//            if bytesWritten > 0 {
//                offset += bytesWritten.littleEndian
//                dataToSendSize -= bytesWritten
//                print(bytesWritten)
//                continue
//            } else if bytesWritten < 0 {
//                // ERROR
//                print("ERROR ERROR ERROR")
//                break
//            } else if bytesWritten == 0 {
//                // SUCCESS
//                print("Completed!!")
//                break
//            }
//            
//        } while CFWriteStreamCanAcceptBytes(ftpWriteStream)
//       var bytesWritten = 0
//        while (bytesWritten > 0) {
//            bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
//            if bytesWritten > 0 {
//                offset += bytesWritten.littleEndian
//                dataToSendSize -= bytesWritten
//                print(bytesWritten)
//                continue
//            } else if bytesWritten < 0 {
//                // ERROR
//                print("ERROR ERROR ERROR")
//                return false
//                break
//            } else if bytesWritten == 0 {
//                // SUCCESS
//                print("Completed!!")
//                break
//            }
//            
//        }
        
        return true
    }
    
  
    class func deleteFileFromFTP(fileName:String)
    {
    
        let username = Constant.FTP_USERNAME.replacingOccurrences(of: "@", with: "%40")
        
        let password = Constant.FTP_PASSWORD.replacingOccurrences(of: "@", with: "%40")
        
        let hostName = Constant.FTP_HOST_NAME
        
        let directoryPath = Constant.FTP_DIRECTORY_PATH + "jk"
        
        let downloadFileName = fileName.replacingOccurrences(of: " ", with: "%20")
        
        // NSString* urlString=[NSString stringWithFormat:@"ftp://%@:%@%@%@%@",username,password,FTPHostName,FTPFilesFolderName,downloadableAttachmentName];
        
        let fullyQualifiedPath = "ftp://\(username):\(password)\("@")\(hostName)/\(directoryPath)/\(downloadFileName)"
        
        let downloadUrl = URL(string: fullyQualifiedPath)
        
        let legIntPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: 255)

        //let legIntPtr: UnsafeMutablePointer<UInt8>
        
        let  P_MAX = 255
        //char path[P_MAX];
        
        let path = [P_MAX]
        
        // get C-String from CFStringRef
        _ = CFURLGetFileSystemRepresentation(downloadUrl! as CFURL?, true, legIntPtr, P_MAX)
        
//        print(ret)
        if (!CFURLGetFileSystemRepresentation(downloadUrl! as CFURL?, true, legIntPtr, P_MAX))
        {
            // error
//            print("error occured")
        }
        else
        {
//          print("seccuess")
        }
        let leg = UnsafeMutablePointer<Int32>.allocate(capacity: 255)

        //CFURLGetFileSystemRepresentation(<#T##url: CFURL!##CFURL!#>, <#T##resolveAgainstBase: Bool##Bool#>, <#T##buffer: UnsafeMutablePointer<UInt8>!##UnsafeMutablePointer<UInt8>!#>, <#T##maxBufLen: CFIndex##CFIndex#>)
//        _ = CFURLDestroyResource(downloadUrl as CFURL!, leg)
//    
//        removefile(3)
    }

//    func callback(ftpWriteStream:CFWriteStream,buffer:UnsafeMutablePointer<UInt8>, dataToSendSize:Int)
//    {
//        let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
//        if bytesWritten > 0 {
//            offset += bytesWritten.littleEndian
//            dataToSendSize -= bytesWritten
//            print(bytesWritten)
//        } else if bytesWritten < 0 {
//            // ERROR
//            print("ERROR ERROR ERROR")
//        } else if bytesWritten == 0 {
//            // SUCCESS
//            print("Completed!!")
//        }
//
//    }
}

