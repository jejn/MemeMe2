//
//  ViewController.swift
//  MemeMe2
//
//  Created by Jim Nording on 23/12/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    
    // Global variables
    
    var editMeme: Meme?
    
    let imagePicker = UIImagePickerController()
    let topPlaceholder = "TOP"
    let bottomPlaceholder = "BOTTOM"
    
    let memeTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    
    
    
    // Outlets
    
    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    
    
    
    
    // View Lifecycles
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        // Delegates
        imagePicker.delegate = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // Enable cameraButton if camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        // Set text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = topPlaceholder
        topTextField.textAlignment = .Center
        textFieldDidBeginEditing(topTextField)
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = bottomPlaceholder
        bottomTextField.textAlignment = .Center
        textFieldDidBeginEditing(bottomTextField)
        
        // If editMeme, sets image and text
        if let meme = editMeme {
            memeView.image = meme.originalImage
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            shareButton.enabled = true
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    
    
    
    
    
    
    // Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == topPlaceholder || textField.text == bottomPlaceholder {
            textField.clearsOnBeginEditing = true
        } else {
            textField.clearsOnBeginEditing = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeigth(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeigth(notification)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeigth(notification)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        memeView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
        
        // Enable shareButton
        shareButton.enabled = true
        
        // Found tutorial: ( https://www.youtube.com/watch?v=1EmGRVlifhw )
    }
    
    func alertMessage(title: String, message: String) {
        
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertMessage.addAction(okAction)
        
        self.presentViewController(alertMessage, animated: true, completion: nil)
        
        // Found tutorial: ( https://www.youtube.com/watch?v=3vMTpBCFljY )
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        
        // Create the meme object
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeView.image!, memedImage: memedImage)
        
        // Add to memes Array in AppDelegate.swift
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    
    
    
    
    
    // Actions
    
    @IBAction func accessCamera(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: nil)
                
            } else {
                alertMessage("Error", message: "There is a problem to access the camera")
            }
            
        } else {
            alertMessage("Access Required", message: "Allow Access to camera to take photo")
        }
    }
    
    @IBAction func accessPhotoAlbum(sender: AnyObject) {
        
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        // Generate a memed image
        let memedImage = generateMemedImage()
        
        // Define an instance of the ActivityViewController
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        
        // Present the ActivityViewController
        presentViewController(activityView, animated: true, completion: nil)
        
        activityView.completionWithItemsHandler = { (activity: String?, success: Bool, items: [AnyObject]?, error: NSError?) in
            if success {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}


