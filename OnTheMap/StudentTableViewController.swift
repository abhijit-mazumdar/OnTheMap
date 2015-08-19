//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var studentsTableView: UITableView!
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.studentsTableView.reloadData()
            }
            else{
                Helper.displayAlert(inViewController: self.alert!, withTitle: "Error", message: "Error dowmloading student data", completionHandler: { (alertAction) -> Void in
                    self.alert!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var studentLocations = StudentClient.sharedInstance().studentLocations
        self.studentsTableView.reloadData()
    }
    
    @IBAction func refreshStudents(sender: AnyObject) {
        StudentClient.sharedInstance().getStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.studentsTableView.reloadData()
            }
            else{
                Helper.displayAlert(inViewController: self.alert!, withTitle: "Error", message: "Error dowmloading student data", completionHandler: { (alertAction) -> Void in
                    self.alert!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    // Logout Button
    @IBAction func logoutButton(sender: AnyObject) {
        UdacityClient.sharedInstance().logoutSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Table View Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentClient.sharedInstance().studentLocations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableViewCell",forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = StudentClient.sharedInstance().studentLocations[indexPath.row].description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: StudentClient.sharedInstance().studentLocations[indexPath.row].mediaURL)!)
    }
    
}
