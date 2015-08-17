//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Abhijit Mazumdar on 5/3/15.
//  Copyright (c) 2015 Abhijit Mazumdar. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var studentLocations = [StudentLocation]()
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        studentLocations = StudentClient.sharedInstance().studentLocations
        self.studentsTableView.reloadData()
    }
    
    @IBAction func refreshStudents(sender: AnyObject) {
        self.studentsTableView.reloadData()
    }
    
    //MARK: Table View Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentTableViewCell",forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = "\(studentLocations[indexPath.row].description)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: studentLocations[indexPath.row].mediaURL)!)
    }
    
}
