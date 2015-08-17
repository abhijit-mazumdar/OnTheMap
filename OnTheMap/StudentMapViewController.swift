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

class StudentMapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selected: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.loadStudentAnnotationsToMapView()
            }
        }
        
    }
    
   // Refresh Button
    @IBAction func refreshStudents(sender: AnyObject) {
        loadStudentAnnotationsToMapView()
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
