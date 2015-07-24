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
    
    // MARK: - Shared Instance

class func sharedInstance() -> StudentClient {
    
    struct Singleton {
        static var sharedInstance = StudentClient()
    }
    
    return Singleton.sharedInstance
}

}