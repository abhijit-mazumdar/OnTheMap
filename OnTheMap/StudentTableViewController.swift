//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UINavigationBarDelegate {
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Helper.isConnectedToNetwork(){
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
        } else {
            var alert = UIAlertController(title: "Network error", message: "Please make sure device is connected to Wi-Fi or phone data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44))
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "On The Map"
        
        // Create left and right button for navigation item
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButton")
        let postButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "tapPost")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshStudents")
        
        // Create three buttons for the navigation item
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.setRightBarButtonItems([refreshButton,postButton], animated: true)
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)

        // Reload table view
        var studentLocations = StudentClient.sharedInstance().studentLocations
        self.studentsTableView.reloadData()
        
    }
    
    func refreshStudents() {
        if Helper.isConnectedToNetwork(){
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
        } else {
            var alert = UIAlertController(title: "Network error", message: "Please make sure device is connected to Wi-Fi or phone data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    // Logout Button
    func logoutButton() {
        UdacityClient.sharedInstance().logoutSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Load Information posting view
    func tapPost(){
        let vc: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
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
