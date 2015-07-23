//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation
import UIKit

class StudentLocation {
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var fullName: String{
        get{
            return self.firstName + " " + self.lastName
        }
    }
    
    init(firstName: String, lastName: String,mapString: String, mediaURL: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    
    //Get Student Locations from result dictionary
    static func studentLocationFromResults(results: NSArray) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results{
            studentLocations.append(result as! StudentLocation)
        }
        return studentLocations
    }
}
