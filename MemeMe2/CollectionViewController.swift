//
//  CollectionViewController.swift
//  MemeMe2
//
//  Created by Jim Nording on 23/12/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    // Global
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let memeTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    
    
    
    
    
    // Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    

    
    
    
    // View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    
    
    
    
    
    // Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        
        cell.memeView?.image = meme.originalImage
        
        cell.memeCellTextTop?.text = meme.topText
        cell.memeCellTextTop?.defaultTextAttributes = memeTextAttributes
        
        cell.memeCellTextBottom?.text = meme.bottomText
        cell.memeCellTextBottom?.defaultTextAttributes = memeTextAttributes
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let meme = appDelegate.memes[indexPath.row]
        let detailedController = storyboard?.instantiateViewControllerWithIdentifier("DetailedVC") as! DetailedViewController
        
        detailedController.meme = meme
        
        navigationController?.pushViewController(detailedController, animated: true)
    }
    
}