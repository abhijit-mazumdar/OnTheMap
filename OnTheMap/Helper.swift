//
//  Helper.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 8/1/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    // Parse JSON Data
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        if parsingError != nil {
            completionHandler(result: nil, error: parsingError)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    // Display Alert View
    class func displayAlert(inViewController viewController: UIViewController, withTitle title: String, message: String, completionHandler: ((UIAlertAction!) -> Void)) -> UIAlertController {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: completionHandler))
        viewController.presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    // Display Activity indicator
    class func displayActivityIndicator(view : UIView, withActivityIndicator activityIndicator: UIActivityIndicatorView, andAnimate enable: Bool) {
        if enable {
            view.alpha = 0.6
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        } else {
            view.alpha = 1
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
    }
}

