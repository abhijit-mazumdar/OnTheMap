//
//  StudentClient.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 7/23/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation

class StudentClient : NSObject{

    /* Shared session */
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // MARK: - Shared Instance

class func sharedInstance() -> StudentClient {
    
    struct Singleton {
        static var sharedInstance = StudentClient()
    }
    
    return Singleton.sharedInstance
}

}