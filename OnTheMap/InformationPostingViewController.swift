//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 7/30/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var promptLabel: UILabel!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var findMapButton: UIButton!
    
    @IBOutlet weak var linkTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    var userLocation: CLLocation?
    var mapString: String?
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextView.hidden = true
        mapView.hidden = true
        submitButton.hidden = true
        activityIndicator.hidden = true
        
        submitButton.layer.cornerRadius = 5
        findMapButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Forward geocode the location text view string and show on mapview
    @IBAction func forwardGeocodeAction(sender: AnyObject) {
        activityIndicator.hidden = false
        var geoCoder = CLGeocoder()
        Helper.displayActivityIndicator(self.view, withActivityIndicator: self.activityIndicator, andAnimate: true)
        geoCoder.geocodeAddressString(locationTextView.text, completionHandler: { (placemarks, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                
            })
            if error == nil {
                self.submitButton.hidden = false
                self.mapView.hidden = false
                self.linkTextView.hidden = false
                self.submitButton.hidden = false
                
                self.promptLabel.hidden = true
                self.locationTextView.hidden = true
                self.findMapButton.hidden = true
                
                self.linkTextView.becomeFirstResponder()
                
                self.mapString = self.locationTextView.text
                
                for placemark in placemarks
                {
                    self.userLocation = (placemark as! CLPlacemark).location
                    
                    var enteredLocationAnnotation = MKPointAnnotation()
                    enteredLocationAnnotation.coordinate = self.userLocation!.coordinate
                    
                    self.mapView.addAnnotation(enteredLocationAnnotation)
                    
                    self.mapView.centerCoordinate = self.userLocation!.coordinate
                    
                    var scale = abs((cos(2 * M_PI * self.userLocation!.coordinate.latitude / 360.0) ))
                    
                    var span = MKCoordinateSpan(latitudeDelta: 5/60.0, longitudeDelta: 5/(scale*60.0))
                
                    var region = MKCoordinateRegion(center: self.userLocation!.coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)

                }
                Helper.displayActivityIndicator(self.view, withActivityIndicator: self.activityIndicator, andAnimate: false)
            } else {
                var alert = UIAlertController(title: "Geocode Failed", message: "Please enter location in format like Mountain View,CA", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            
            }
            
        })
        
    }
    
    // Post student information
    @IBAction func submitLink(sender: AnyObject) {
        var mediaURL = self.linkTextView.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: mediaURL)!) {
            Helper.displayActivityIndicator(self.view, withActivityIndicator: self.activityIndicator, andAnimate: true)
            StudentClient.sharedInstance().postStudentLocation(self.mapString!, location: self.userLocation!, mediaURL: mediaURL, completionHandler: { (success, errorString) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    Helper.displayActivityIndicator(self.view, withActivityIndicator: self.activityIndicator, andAnimate: false)
                })
                Helper.displayActivityIndicator(self.view, withActivityIndicator: self.activityIndicator, andAnimate: false)
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.raiseRetryAlert("Error", message: errorString!)
                }
            })
        } else {
            alert = Helper.displayAlert(inViewController: self, withTitle:"Error", message: "Link is invalid. Please enter a valid URL.", completionHandler: { (alertAction) -> Void in
                self.alert!.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    
    }
    
    func raiseRetryAlert(title: String, message: String) {
        
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add Actions to UIAlertController
        alert!.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: alertActionHandler))
        alert!.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: alertActionHandler))
        
        self.presentViewController(alert!, animated: true, completion: nil)
        
    }
    
    func alertActionHandler(sender: UIAlertAction!) -> Void{
        if(sender.title == "Retry"){
            submitLink(self)
        } else if(sender.title == "Cancel" || sender.title == "Ok") {
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Keyboard Fixes
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
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
}
