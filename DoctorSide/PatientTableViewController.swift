//
//  PatientTableViewController.swift
//  ParseStarterProject
//
//  Created by 农仕彪 on 15/7/27.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import Parse
class PatientTableViewController: UITableViewController {

    // MARK: Properties
    

    var patients = [Patient]()
    var tempPatient = Patient(name: "", textInfo: "", objectID: "")
    var selectedObjectId = String()
    var tempString = String()
    var Text = "le"
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSamplePatients()
    }

    func loadSamplePatients() {
        /*
        var query = PFQuery(className:"patient")
        //for tempString in itemObjectId{
            query.getObjectInBackgroundWithId("ofeFERPC8s") {
                (patient: PFObject?, error: NSError?) -> Void in
                if error == nil && patient != nil {
                    //println(gameScore2)
                    let Name = patient!.objectForKey("Name") as! NSString
                    let foodRequestFlag = patient!.objectForKey("FoodRequestFlag") as! NSNumber
                    if(foodRequestFlag == 1){
                        let Text = "Food request has been sent"
                    }
                    else{
                        let Text = "Food request has not been sent"
                    }
                    let patient2 = Patient(name: "efg", textInfo: self.Text, objectID: "bvwHXybqQk")!
                    let patient1 = Patient(name: "Abc", textInfo: "hello", objectID: "ofeFERPC8s")!
                    self.patients += [patient2, patient1]
                    //self.patients.append(tempPatient!)
    
                }
                else {
                    println(error)
                }
            }
        */
        //let Text = "There are some problem"
        let patient1 = Patient(name: "Abc", textInfo: Text, objectID: "ofeFERPC8s")!
        let patient2 = Patient(name: "efg", textInfo: Text, objectID: "bvwHXybqQk")!
        patients += [patient1, patient2]
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PatientTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PatientTableViewCell

        // Configure the cell...
        let patient = patients[indexPath.row]
        //cell.nameLabel.text = patient.name
        //cell.situationText.text = patient.textInfo
        cell.patientObjectId = patient.objectID
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow();
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! PatientTableViewCell!;
        selectedObjectId = currentCell.patientObjectId
        performSegueWithIdentifier("patientView", sender: self)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "patientView") {
            var destViewController: PatientViewController = segue.destinationViewController as! PatientViewController
            destViewController.patientObjectId = selectedObjectId
        }
    }
    */
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
