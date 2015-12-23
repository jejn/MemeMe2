//
//  TableViewController.swift
//  MemeMe2
//
//  Created by Jim Nording on 23/12/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Access to memes array in AppDelegate.swift
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Get number of rows from memes Array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")! as UITableViewCell
        let meme = appDelegate.memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let meme = appDelegate.memes[indexPath.row]
        let detailedController = storyboard?.instantiateViewControllerWithIdentifier("DetailedVC") as! DetailedViewController
        
        detailedController.meme = meme
        
        navigationController?.pushViewController(detailedController, animated: true)
    }
    
    
}
