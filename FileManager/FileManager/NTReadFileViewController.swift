//
//  NTReadFileViewController.swift
//  Communicator
//
//  Created by ChinaTeam on 16/7/15.
//  Copyright © 2016年 Neatlyco. All rights reserved.
//

import UIKit

class NTReadFileViewController: UIViewController {

    var filePath:String?
    let webView:UIWebView =  UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.createUI()
       self.loadDocument()
    }

    func createUI(){
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        webView.scalesPageToFit  = true
    }
    
    
    func loadDocument(){
        
        if filePath != nil {
            webView.loadRequest( NSURLRequest(URL: NSURL.fileURLWithPath(filePath!)))
        }

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
