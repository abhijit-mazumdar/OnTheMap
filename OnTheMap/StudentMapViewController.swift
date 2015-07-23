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
    //var StudentLocation[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadStudentAnnotationsToMapView()
    }
    
   
    // Load student anotations from JSON
    func loadStudentAnnotationsToMapView() {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                if let results = parsedResult["results"] as? NSArray{
                    for result in results{
                        var firstName = result["firstName"] as! String
                        var lastName = result["lastName"] as! String
                        //var latitude = result["latitiude"] as! CLLocationDegrees
                        var latitude: CLLocationDegrees = 34.7303688
                        var longitude = result["longitude"] as! CLLocationDegrees
                        var mapString = result["mapString"] as! String
                        var mediaURL = result["mediaURL"] as! String
                        var title = firstName + " " + lastName
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(latitude,longitude)
                        annotation.title = title
                        annotation.subtitle = mediaURL
                        self.mapView.addAnnotation(annotation)
                    }
                }
                
            }
        }
        task.resume()
    }
}
