//
//  NTFileManager.swift
//  FileManager
//
//  Created by ChinaTeam on 16/7/14.
//  Copyright © 2016年 Neatlyco. All rights reserved.
//

import UIKit
import Alamofire

class NTFileManager: NSObject {

    
      internal class func shareNTFileManager() -> NTFileManager {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var util : NTFileManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.util = NTFileManager()
            
        }
        return Static.util!
     }
    
    
    
    let fileManager:NSFileManager = NSFileManager.defaultManager()
    
    //MARK: get path
     func getDocumentsPath()->NSString {
        
     let paths:Array =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        println("paths\(paths[0])" )
         return  paths[0]
    }
    
    //MARK: create Directory
     func createDirectory(directoryName:String)->String{
        let documentsPath:NSString = self.getDocumentsPath()
        let testDirectory:String =  documentsPath.stringByAppendingPathComponent(directoryName)
        if  !fileManager.fileExistsAtPath(directoryName) {
            do {
                try fileManager.createDirectoryAtPath(testDirectory, withIntermediateDirectories: true, attributes: nil)
             
            }catch {
                print(error)
                return ""
                   }
        }
           return  testDirectory
    }
    
        
        //MARK :remove file
    func deleteFile(filePath:String)->Bool{
            do {
                    try fileManager.removeItemAtPath(filePath)
                    return  true
                }catch {
                    print(error)
                }
          
            return  false
        }


    //MARK:  getDirAllfileList
    func getDirAllFileList(dirName:String)->Array<String>{
        
        let  docPatch:NSString =  self.getDocumentsPath()
        let  path:String  = docPatch.stringByAppendingPathComponent(dirName)
        
        return self.fileManager.subpathsAtPath(path)!
    }
    
    func  getDirAllFolderList(dirName:String)->Array<String>{
        let fileList:Array<String> =  self.fileManager.subpathsAtPath(dirName)!
        var dirArray:Array<String>  = Array<String>()
        var isDir:ObjCBool = false
        //get fileList item is folder
        for file in fileList {
            let  docPatch:NSString =  self.getDocumentsPath()
            let  path:String  = docPatch.stringByAppendingPathComponent(file)
            
            fileManager.fileExistsAtPath(path, isDirectory: &isDir)
            if isDir && file !=  ".DS_Store" {
                dirArray.append(file)
            }
            isDir = false;
            
        }
     
//        println("Every Thing in the dir:\(fileList)")
//        println("All folders:\(dirArray)");
        return dirArray
    }
    
    
    //MARK:  move file to new path
    func moveFileToNewDir(srcPath:String,newDirPath:NSString)->Bool{
        let fileName:String = srcPath.componentsSeparatedByString("/").last!
        let newFilePath:String = newDirPath.stringByAppendingPathComponent(fileName)
        do {
                try  fileManager.moveItemAtPath(srcPath, toPath: newFilePath)
                return  true
            }catch {
                print(error)
            }
          return  false
       
    }
   
    //MARK: download file
    func downloadFileAndSaveToSendBox(fileUrl:String,downloadResult:(result:NSURL)->Void)->String{
         Alamofire.download(.GET, fileUrl) {
            temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
                                                            inDomains: .UserDomainMask)[0]
            //chose dir
            let fileType:String = fileUrl.componentsSeparatedByString(".").last!
            
            let folder = directoryURL.URLByAppendingPathComponent(fileType, isDirectory: true)
            //create folder
            let exist = fileManager.fileExistsAtPath(folder.path!)
            if !exist {
                try! fileManager.createDirectoryAtURL(folder, withIntermediateDirectories: true,
                                                      attributes: nil)
            }
            let fileName:String = fileUrl.componentsSeparatedByString("/").last!
            let result:NSURL = folder.URLByAppendingPathComponent(fileName)
                      downloadResult(result: result)
            return result
           
        }
        
     
        return ""
    }
    
    
    func getFileAttrites(filePath:String)->[String : AnyObject]{
        
       
        do {
         let dict:Dictionary<String,AnyObject> = try self.fileManager.attributesOfItemAtPath(filePath)
//            ["NSFileCreationDate": 2016-07-15 03:32:24 +0000, "NSFileGroupOwnerAccountName": staff, "NSFileExtensionHidden": 0, "NSFileSize": 40448, "NSFileGroupOwnerAccountID": 20, "NSFileOwnerAccountID": 501, "NSFilePosixPermissions": 384, "NSFileType": NSFileTypeRegular, "NSFileSystemFileNumber": 27569343, "NSFileSystemNumber": 16777220, "NSFileReferenceCount": 1, "NSFileModificationDate": 2016-07-15 03:32:25 +0000]
//            println( dict)
            return dict
        }catch{
            print(error)
        }
       return [:]
    }
    
       
}




