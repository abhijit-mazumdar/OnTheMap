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
                }
            } else {
                var alert = UIAlertController(title: "Geocode Failed", message: "Please enter location in format like Mountain View,CA", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            
            }
            
        })
        
    }
    
    

}
