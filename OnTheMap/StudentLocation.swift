//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation

class StudentLocation : NSObject{
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    
    init(firstName: String, lastName: String, mapString: String, mediaURL: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    
}
