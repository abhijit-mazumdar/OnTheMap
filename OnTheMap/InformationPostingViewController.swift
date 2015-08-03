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
    
    var userLocation: CLLocation?
    var mapString: String?
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextView.hidden = true
        mapView.hidden = true
        submitButton.hidden = true
        
        submitButton.layer.cornerRadius = 5
        findMapButton.layer.cornerRadius = 5
    }
    
    // Forward geocode the location text view string and show on mapview
    @IBAction func forwardGeocodeAction(sender: AnyObject) {
        var geoCoder = CLGeocoder()
        
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
            StudentClient.sharedInstance().postStudentLocation(self.mapString!, location: self.userLocation!, mediaURL: mediaURL, completionHandler: { (success, errorString) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                })
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    var alert = UIAlertController(title: "Post Link Failed", message: "Please enter URL in format like http://www.google.com", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
            alert = Helper.displayAlert(inViewController: self, withTitle:"Error", message: "Link is invalid. Please enter a valid URL.", completionHandler: { (alertAction) -> Void in
                self.alert!.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    
    }
}
