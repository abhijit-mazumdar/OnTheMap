//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 8/1/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{

    var session: NSURLSession
    var user: UdacityUser!
    
    override init() {
        session = NSURLSession.sharedSession()
        user = UdacityUser()
        super.init()
    }
    
    // Udacity authentication
    func authenticate(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.URLS.Session)!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.JSONType, forHTTPHeaderField: "Accept")
        request.addValue(Constants.JSONType, forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Error communicating with Udacity API Session.")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                Helper.parseJSONWithCompletionHandler(newData, completionHandler: { (result, error) -> Void in
                    
                    if error == nil {
                        if let errorString = result["error"] as? String {
                            completionHandler(success: false, errorString: errorString)
                        } else {
                            let accountDetails = result["account"] as! NSDictionary
                            self.user.userId = accountDetails["key"] as? NSString
                            self.getStudentData(completionHandler)
                        }
                    } else {
                        completionHandler(success: false, errorString: error!.description)
                    }
                })
            }
        }
        task.resume()
        
    }
    
    // Udacity Logout
    func logoutSession(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    // Get student data
    func getStudentData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(UdacityClient.URLS.PublicUser)/\(user.userId!)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(success: false, errorString: "Error loading Udacity Student data")
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            Helper.parseJSONWithCompletionHandler(newData, completionHandler: { (result, error) -> Void in
                let userDetails = result["user"] as! NSDictionary
                self.user.firstName = userDetails["first_name"] as? NSString
                self.user.lastName = userDetails["last_name"] as? NSString
                
                completionHandler(success: true, errorString: nil)
            })
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}

extension UdacityClient {
    
    struct Constants {
        static let SignInURL : String = "https://www.udacity.com/account/auth#!/signin"
        static let JSONType : String = "application/json"
    }
    
    struct URLS{
        static let Session: String = "https://www.udacity.com/api/session"
        static let PublicUser: String = "https://www.udacity.com/api/users"
    }
    
}
