//
//  NTFileLibraryTableViewController.swift
//  FileManager
//
//  Created by ChinaTeam on 16/7/14.
//  Copyright © 2016年 Neatlyco. All rights reserved.
//

import UIKit
import MobileCoreServices

class NTFileLibraryTableViewController: UITableViewController {

    
      
   let fileUrls = [
                   "http://yd1.pptbz.com/200904/2014112970525017.ppt",
                   "http://yd1.pptbz.com/201202/2014112840320297.ppt",
                   "http://pdf-file.ic37.com/PdfOld/MAXIM/MAX64_datasheet_91191/148298/MAX64_datasheet.pdf",
                   "http://jianli.yjbys.com/uploads/soft/201607/3938-160F6135104.doc",
                   "http://mmm.onegreen.net/sucai/office/20120814003.xls",
                   ]

    let iconDict:Dictionary<String,String> = ["ppt":"ICON-filter-ppt","doc":"ICON-filter-docs","xls":"ICON-filter-excel","pdf":"ICON-filter-pdf","all file":"ICON-filter-other"]


    
    //folder list data
    var folderNameList:Array<String> = []
    var folderSubFilePaths:Array<Array<String>> = []
    
    override func loadView() {
        super.loadView()
        //down load file
        for urlStr in fileUrls {
            NTFileManager.shareNTFileManager().downloadFileAndSaveToSendBox(urlStr, downloadResult: { (result) in
            })
        }
       
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "File List"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(NTFileListTableViewController.doneAction))
    }
    
    func doneAction(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.initDataList()
         self.tableView.reloadData()
    }
    
  //MARK: initDataList
    func initDataList(){
        //init data list
        self.folderNameList.removeAll()
        self.folderNameList = NTFileManager.shareNTFileManager().getDirAllFolderList(NTFileManager.shareNTFileManager().getDocumentsPath() as String)
        self.folderNameList.insert("all file", atIndex: 0)
        
        var tempArrat:Array<String> = []
        self.folderSubFilePaths.removeAll()
        self.folderSubFilePaths.insert(tempArrat, atIndex: 0)
        if self.folderNameList.count > 1 {
            for  index  in 1...self.folderNameList.count-1 {
                //get dir file name
                let files:Array<String> =  NTFileManager.shareNTFileManager().getDirAllFileList(self.folderNameList[index])
//                println(files.first)
                //change to file path
                var filePaths:Array<String> = []
                for  fileName in files {
                    let dirPath:NSString = NTFileManager.shareNTFileManager().getDocumentsPath().stringByAppendingPathComponent(self.folderNameList[index])
                    filePaths.append(dirPath.stringByAppendingPathComponent(fileName))
                }
                self.folderSubFilePaths.insert(filePaths, atIndex: index)
                tempArrat.appendContentsOf(filePaths)
            }
        }
         self.folderSubFilePaths.removeAtIndex(0)
         self.folderSubFilePaths.insert(tempArrat, atIndex: 0)
        
         self.tableView.reloadData()
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
        return folderNameList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:NTFileLibraryTableViewCell? = tableView.dequeueReusableCellWithIdentifier("myfolderCell") as? NTFileLibraryTableViewCell
        if cell == nil {
            cell = NTFileLibraryTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "myfolderCell")
            cell?.accessoryType = .DisclosureIndicator
        }
       
        cell?.nt_titleLabel.text = self.folderNameList[indexPath.row]
        cell?.nt_subTitleLabel.text = "\(self.folderSubFilePaths[indexPath.row].count)"
        if self.iconDict[self.folderNameList[indexPath.row]] != nil {
        cell?.setIcon(self.iconDict[self.folderNameList[indexPath.row]]!)
        }
      
        return cell!
    }
 
    
   
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        //get data
        let fileListVC:NTFileListTableViewController = NTFileListTableViewController()
         fileListVC.title = self.folderNameList[indexPath.row]
         fileListVC.initData(self.folderSubFilePaths[indexPath.row])
        self.navigationController?.pushViewController(fileListVC, animated: true)
        
    }

}


class NTFileLibraryTableViewCell: UITableViewCell {
    
    let nt_iconLabel:UIImageView = UIImageView()
    let nt_titleLabel:UILabel = UILabel()
    let nt_subTitleLabel:UILabel  = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createUI(){
        self.contentView.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(nt_iconLabel)
        self.contentView.addSubview(nt_titleLabel)
        self.contentView.addSubview(nt_subTitleLabel)
        nt_iconLabel.translatesAutoresizingMaskIntoConstraints = false
        nt_titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nt_subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nt_subTitleLabel.font = UIFont.systemFontOfSize(10)
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_iconLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 15))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_iconLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 10))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_iconLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -10))
         self.nt_iconLabel.addConstraint(NSLayoutConstraint(item: nt_iconLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem:   nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50))
         self.nt_iconLabel.addConstraint(NSLayoutConstraint(item: nt_iconLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem:   nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50))
        
         self.contentView.addConstraint(NSLayoutConstraint(item: nt_titleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:   nt_iconLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 15))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:   self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 10))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_subTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:   nt_iconLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 15))
        self.contentView.addConstraint(NSLayoutConstraint(item: nt_subTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:   self.nt_titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
        
    }
    
    func setIcon(iconName:String){
        self.nt_iconLabel.image = UIImage(named: iconName)
    }
    
    
}

