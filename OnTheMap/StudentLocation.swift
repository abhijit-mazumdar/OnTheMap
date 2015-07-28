//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {
    var uniqueKey:String
    var firstName:String
    var lastName:String
    var mapString:String
    var mediaURL:String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var annotation: MKPointAnnotation
    
    var description: String {
        return "\(firstName) \(lastName)"
    }
    
    
    init(dictionary: NSDictionary) {
        uniqueKey = (dictionary["uniqueKey"] as? String)!
        firstName = (dictionary["firstName"] as? String)!
        lastName = (dictionary["lastName"] as? String)!
        mapString = (dictionary["mapString"] as? String)!
        mediaURL = (dictionary["mediaURL"] as? String)!
        let lat = (dictionary["latitude"] as? Double)!
        latitude = CLLocationDegrees(lat)
        let lon = (dictionary["longitude"] as? Double)!
        longitude = CLLocationDegrees(lon)
        annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
    }
    
    // Helper function to get student locations from results 
    static func studentsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var students = [StudentLocation]()
        
        for result in results {
            students.append(StudentLocation(dictionary: result))
        }
        return students
    }
}
