//
//  DetailedViewController.swift
//  MemeMe2
//
//  Created by Jim Nording on 23/12/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import Foundation
import UIKit

class DetailedViewController: UIViewController {
    
    var meme: Meme?
    
    @IBOutlet weak var detailedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailedImageView.image = meme?.memedImage
    }
    
    @IBAction func editButton(sender: AnyObject) {
        
        let editController = storyboard?.instantiateViewControllerWithIdentifier("MemeVC") as! MemeViewController
        
        editController.editMeme = meme
        
        navigationController?.popToViewController(editController, animated: true)
    }
}
