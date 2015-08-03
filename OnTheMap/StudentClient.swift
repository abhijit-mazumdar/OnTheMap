//
//  StudentClient.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 7/23/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation
import MapKit

class StudentClient : NSObject{

    /* Shared session */
    var session: NSURLSession
    
    var studentLocations: [StudentLocation] = []
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: - Get and Post Student Locations
    
    func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var temp: [StudentLocation] = []
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("Could not complete the request \(error)")
                completionHandler(success: false, errorString: error.description)
            } else {
                StudentClient.parseJSONWithCompletionHandler(data) { (result, error) -> Void in
                    if let results = result["results"] as? [AnyObject] {
                        for result in results {
                            var student = StudentLocation(dictionary: result as! NSDictionary)
                            temp.append(student)
                        }
                        self.studentLocations = temp
                        completionHandler(success: true, errorString: nil)
                    }else {
                        completionHandler(success: false, errorString: "Problem in result data.")
                    }
                }
            }
        }
        task.resume()
      }

    func postStudentLocation(mapString: String, location: CLLocation, mediaURL: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
            var tempStudentLocations: [StudentLocation] = []
            let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
            request.HTTPMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.HTTPBody = "{\"uniqueKey\": \"324586\", \"firstName\": \"\(UdacityClient.sharedInstance().user.firstName!)\", \"lastName\": \"\(UdacityClient.sharedInstance().user.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\":\(location.coordinate.latitude), \"longitude\": \(location.coordinate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    completionHandler(success: false, errorString: error.description)
                } else {
                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    Helper.parseJSONWithCompletionHandler(data) { (result, error) -> Void in
                        println(result)
                    }
                    completionHandler(success: true, errorString: nil)
                }
            }
            task.resume()
    }


    /* Helper: Given raw JSON, return a usable Foundation object */
     class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    


    // MARK: - Shared Instance
   class func sharedInstance() -> StudentClient {
    
    struct Singleton {
        static var sharedInstance = StudentClient()
    }
    
    return Singleton.sharedInstance
}

}
