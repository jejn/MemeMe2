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
}
