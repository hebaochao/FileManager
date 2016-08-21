//
//  NTFileListTableViewController.swift
//  FileManager
//
//  Created by ChinaTeam on 16/7/15.
//  Copyright © 2016年 Neatlyco. All rights reserved.
//

import UIKit

class NTFileListTableViewController: UITableViewController {
    

    //file name (not folderName)
    var filePathList:Array<String>?
    //file info data list
    var dataArray:Array<[String : AnyObject]> = []
    //right btn
    var donBtn:UIBarButtonItem?
    //is select index
    var selectArray:Array<Bool> = []
    
    func initData(filePathList:Array<String> ) {
        self.filePathList = filePathList
        //get file info list
        for  filepath in filePathList {
            dataArray.append( NTFileManager.shareNTFileManager().getFileAttrites(filepath))
        }
        //init select index  set <bool>
        selectArray.removeAll()
        if self.filePathList?.count > 0 {
            for    index in  0...(self.filePathList?.count)! - 1 {
                selectArray.insert(false, atIndex: index)
            }
        }
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        donBtn =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(NTFileListTableViewController.doneAction))
        self.navigationItem.rightBarButtonItem = donBtn
        self.changeDoneStateAction()
    }
    
    
    func changeDoneStateAction(){
        
        for isselect  in selectArray {
            if isselect {
              self.donBtn?.enabled = true
                return
            }
        }
        self.donBtn?.enabled = false
    }
    
    
    func doneAction(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:NTFileListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("myfilelistcell") as? NTFileListTableViewCell
        if cell == nil {
            cell = NTFileListTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "myfilelistcell")
            cell?.accessoryType = .DisclosureIndicator
        }
         //set data
        let data:Dictionary<String,AnyObject> = self.dataArray[indexPath.row]
        //set file name
        let filePath:String = self.filePathList![indexPath.row]
        cell?.nt_titleLabel.text  = filePath.componentsSeparatedByString("/").last!
        //set file date
        let date:NSDate  = (data[NSFileCreationDate] as? NSDate)!
        let str:Array<String>  =  date.description.componentsSeparatedByString("+")
        cell?.nt_subTitleLabel.text = str.first!
        //set check btn
        cell?.nt_checkBtn.tag = indexPath.row
        cell?.nt_checkBtn.addTarget(self, action: #selector(NTFileListTableViewController.selectBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //set file size
        print()
        var fileSize:Float = data[NSFileSize] as! Float
        fileSize = fileSize/(1024.0*1024.0)
        cell?.nt_rightLabel.text = String(format: "%.2fMB", fileSize)

        
        return cell!

    }
 
    
    func selectBtnAction(btn:UIButton){
        btn.selected = !btn.selected
            //get select index
        self.selectArray[btn.tag] =  btn.selected
        self.changeDoneStateAction()
    }
    
  //MARK: tableview delegate --- didSelectRowAtIndexPath
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let  readFileVC:NTReadFileViewController = NTReadFileViewController()
        readFileVC.filePath = self.filePathList![indexPath.row]
        readFileVC.title = readFileVC.filePath!.componentsSeparatedByString("/").last!
        self.navigationController?.pushViewController(readFileVC, animated: true)
        
    }
  
    
    //MARK: tableview delegate --- editingStyleForRowAtIndexPath
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    
    //MARK: tableview delegate --- commitEditingStyle
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //remove file
        if editingStyle==UITableViewCellEditingStyle.Delete {
            //get file path
            let filePath:String = self.filePathList![indexPath.row]
        
              //delete file 
            if NTFileManager.shareNTFileManager().deleteFile(filePath)  {
                
                //remove file path 
                self.dataArray.removeAtIndex(indexPath.row)
                //remove file info
                self.filePathList?.removeAtIndex(indexPath.row)
                //remove cell
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                //if dir remove
                let  paths:Array<String> = filePath.componentsSeparatedByString("/")
                var  dirPath:String = String()
                for  index in 0...paths.count - 2 {
                    if index == paths.count - 2 {
                       dirPath = dirPath.stringByAppendingString(paths[index])
                    }else{
                       dirPath = dirPath.stringByAppendingString(paths[index]+"/")
                    }
                    
                }
                //get dirPath file item count
                  let files:Array<String> =  NTFileManager.shareNTFileManager().getDirAllFileList(paths[paths.count-2])
                if files.count == 0 {
                    //remove this folder
                    NTFileManager.shareNTFileManager().deleteFile(dirPath)
                }
                
              
            }
            
        }
    }
    
    
    
}







class NTFileListTableViewCell: UITableViewCell {
    
    let nt_checkBtn:UIButton = UIButton()
    let nt_titleLabel:UILabel = UILabel()
    let nt_subTitleLabel:UILabel  = UILabel()
    let nt_rightLabel:UILabel = UILabel()
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createUI(){
        self.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.contentView.addSubview(nt_checkBtn)
        self.contentView.addSubview(nt_titleLabel)
        self.contentView.addSubview(nt_subTitleLabel)
        self.contentView.addSubview(nt_rightLabel)
        nt_checkBtn.translatesAutoresizingMaskIntoConstraints = false
        nt_titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nt_subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nt_rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nt_subTitleLabel.font = UIFont.systemFontOfSize(10)
        nt_rightLabel.font = UIFont.systemFontOfSize(12)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_checkBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 15))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_checkBtn, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        nt_checkBtn.addConstraint(NSLayoutConstraint(item: nt_checkBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30))
        nt_checkBtn.addConstraint(NSLayoutConstraint(item: nt_checkBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30))
     
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:   nt_checkBtn, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 15))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 10))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_subTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:   nt_checkBtn, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 15))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_subTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:   self.nt_titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_subTitleLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -10))
        
        
         self.contentView.addConstraint(NSLayoutConstraint(item: nt_rightLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_rightLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
       
        nt_checkBtn.setImage(UIImage(named: "ICON-circle-check-blue"), forState: UIControlState.Selected)
        nt_checkBtn.setImage(UIImage(named: "ICON-circle-check"), forState: UIControlState.Normal)
        
    }
    
   
    
    
}





