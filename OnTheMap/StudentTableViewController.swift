//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController,UITableViewDataSource{

    var studentLocations = [StudentLocation]()
    var session = NSURLSession.sharedSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        studentLocations = appDelegate.studentLocations
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                if let results = parsedResult["results"] as? [AnyObject]{
                    //self.studentLocations = StudentLocation.studentLocationFromResults(results)
                    for result in results{
                        var firstName = result["firstName"] as! String
                        var lastName = result["lastName"] as! String
                        
                        println(firstName + " " + lastName)
                    }
                    
                } else {
                    println("Could not find results in \(parsedResult)")
                }
            }
        }
        task.resume()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentTableViewCell"
        let studentLocation = studentLocations[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        // Add student name to table view cell text
        cell.textLabel!.text = studentLocation.description
        
        return cell
    }
    
    
}
