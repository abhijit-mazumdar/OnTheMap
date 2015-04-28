//
//  ViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 4/26/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var debugTextLabel: UILabel!
    
    var session: NSURLSession!
    var appDelegate: AppDelegate!
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        self.view.userInteractionEnabled = true
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    // MARK: - Keyboard Fixes
    

    
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        if usernameTextField.text.isEmpty {
            println("Username Empty.")
        } else if passwordTextField.text.isEmpty {
            println("Password Empty.")
        } else {
            getUdacitySession()
        }
    }
    
    //Get Udacity Login Session
    func getUdacitySession() {
        /* 1. Set the parameters */
        let methodParameters = [
            "username" : usernameTextField.text,
            "password" : passwordTextField.text
        ]
        
        /* 2. Build the URL */
        let urlString = appDelegate.baseURLSecureString + "session" + appDelegate.escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil {
                println("Could not complete the request \(error)")
                return
            } else {
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                println(NSString(data: newData, encoding: NSUTF8StringEncoding))
                println("Login successful")
               
            }
        }
        /* 7. Start the request */
        task.resume()
    }
    
}

