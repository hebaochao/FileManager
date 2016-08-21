//
//  NTTestViewController.swift
//  FileManager
//
//  Created by ChinaTeam on 16/7/14.
//  Copyright © 2016年 Neatlyco. All rights reserved.
//

import UIKit
import MobileCoreServices

class NTFileTestViewController: UITableViewController {

    
   let datalist:Array<String> = ["get file path","create dir ","get dir names list","download a image","show folder vc"," video"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datalist.count
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
   override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("mycell")
       if cell == nil {
          cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "mycell")
       }
       cell?.textLabel?.text = self.datalist[indexPath.row]
       return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            NTFileManager.shareNTFileManager().getDocumentsPath()
        case 1:
            NTFileManager.shareNTFileManager().createDirectory("ppt")
        case 2:
            let array:Array<String> =  NTFileManager.shareNTFileManager().getDirAllFolderList(NTFileManager.shareNTFileManager().getDocumentsPath() as String)
            print( array.count)
              print( array)
        case 3:
            NTFileManager.shareNTFileManager().downloadFileAndSaveToSendBox("http://img5.imgtn.bdimg.com/it/u=1214100453,2355496718&fm=21&gp=0.jpg", downloadResult: { (result) in
                
            })
        case 4:
            self.navigationController?.pushViewController(NTFileLibraryTableViewController(style: UITableViewStyle.Plain), animated: true)
        case 5:
            let imagePickVC:UIImagePickerController = UIImagePickerController()
                        imagePickVC.mediaTypes = [kUTTypeMovie as String]
            
            self.presentViewController(imagePickVC, animated: true, completion: nil)
            
          
        default:
            return
        }
    }
    
}
