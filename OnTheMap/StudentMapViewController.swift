//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StudentMapViewController: UIViewController,MKMapViewDelegate,UINavigationBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var alert: UIAlertController?
    var selected: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        if Helper.isConnectedToNetwork(){
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.loadStudentAnnotationsToMapView()
            }
            else{
                Helper.displayAlert(inViewController: self.alert!, withTitle: "Error", message: "Error dowmloading student data", completionHandler: { (alertAction) -> Void in
                    self.alert!.dismissViewControllerAnimated(true, completion: nil)
            })
            }
        }
        } else {
            var alert = UIAlertController(title: "Network error", message: "Please make sure device is connected to Wi-Fi or phone data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44))
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "On The Map"
        
        // Create left and right button for navigation item
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButton")
        let postButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "tapPost")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshStudents")
        
        // Create three buttons for the navigation item
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.setRightBarButtonItems([refreshButton,postButton], animated: true)
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
   // Refresh Button
    func refreshStudents() {
        if Helper.isConnectedToNetwork(){
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.loadStudentAnnotationsToMapView()
            }
            else{
                Helper.displayAlert(inViewController: self.alert!, withTitle: "Error", message: "Error dowmloading student data", completionHandler: { (alertAction) -> Void in
                    self.alert!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        } else {
            var alert = UIAlertController(title: "Network error", message: "Please make sure device is connected to Wi-Fi or phone data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    // Load student anotations from JSON
    func loadStudentAnnotationsToMapView() {
        for studentLocation in StudentClient.sharedInstance().studentLocations {
            var studentLocationAnnotation = MKPointAnnotation()
            studentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            studentLocationAnnotation.title = "\(studentLocation.description)"
            studentLocationAnnotation.subtitle = "\(studentLocation.mediaURL)"
            self.mapView.addAnnotation(studentLocationAnnotation)
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.setCenterCoordinate(self.mapView.region.center, animated: true)
        })
    }
    
    // Logout Button
    func logoutButton() {
        UdacityClient.sharedInstance().logoutSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Load Information posting view
    func tapPost(){
        let vc: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    // MARK: Map view methods
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.animatesDrop = true
            
            var disclosure = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            disclosure.addTarget(self, action: Selector("openLink:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            pinView!.rightCalloutAccessoryView = disclosure
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func openLink(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: selected!.subtitle!)!)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        //Save the selected annotation
        selected = view.annotation
    }
}
