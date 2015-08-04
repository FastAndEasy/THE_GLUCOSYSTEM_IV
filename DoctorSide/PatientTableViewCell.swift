//
//  PatientTableViewCell.swift
//  ParseStarterProject
//
//  Created by 农仕彪 on 15/7/27.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import Parse
var connectionCount: Int = 30;
class PatientTableViewCell: UITableViewCell {
    var timer:NSTimer!
    var patientObjectId = String()
    // MARK: Properties
    

    @IBAction func refillButton(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId(patientObjectId) {
            (patientChange: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let patientChange = patientChange {
                patientChange["RestInsulin"] = 20
                patientChange.saveInBackground()
            }
        }
    }
    @IBAction func emgButton(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId(patientObjectId) {
            (patientChange: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let patientChange = patientChange {
                patientChange["EmgFlag"] = 0
                patientChange.saveInBackground()
            }
        }
    }
    @IBAction func AcceptButton(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId(patientObjectId) {
            (patientChange: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let patientChange = patientChange {
                let foodRequestFlag = patientChange.objectForKey("FoodRequestFlag") as! NSNumber
                if(foodRequestFlag == 1){
                    patientChange["RequestAcceptFlag"] = 1
                    patientChange.saveInBackground()
                }
                else{
                    self.resultText.text = "Not able to accept yet"
                }
            }
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var situationText: UITextView!
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var PingValue: UITextView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var glucoseText: UITextView!
    @IBOutlet weak var insulinText: UITextView!
    @IBOutlet weak var glucoconText: UITextView!
    @IBOutlet weak var severityLabel: UILabel!
    @IBOutlet weak var emergenceText: UITextView!
    @IBOutlet weak var restInsulin: UITextView!
    //@IBOutlet weak var pingValue: UITextView!
    /*@IBAction func FoodRequestAcceptButton(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId(patientObjectId) {
            (patientChange: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let patientChange = patientChange {
                patientChange["RequestAcceptFlag"] = 1
                patientChange.saveInBackground()
            }
        }

    }
*/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId(patientObjectId) {
            (patient: PFObject?, error: NSError?) -> Void in
            if error == nil && patient != nil {
                //println(gameScore2)
                let Name = patient!.objectForKey("Name") as! NSString
                self.nameLabel.text = Name as String
                let age = patient!.objectForKey("Age") as! NSNumber
                self.ageLabel.text = "Age: " + age.stringValue
                let severity = patient!.objectForKey("severity") as! NSNumber
                self.severityLabel.text = "Severity:" + severity.stringValue
            } else {
                println(error)
            }
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(2,
            target:self,selector:Selector("checkingFoodRequestFlag"),
            userInfo:nil,repeats:true)
        // Configure the view for the selected state
    }
    
    func checkingFoodRequestFlag(){
        var start = NSDate()
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId(patientObjectId) {
            (patient: PFObject?, error: NSError?) -> Void in
            if error == nil && patient != nil {
                //println(gameScore2)
                let foodRequestFlag = patient!.objectForKey("FoodRequestFlag") as! NSNumber
                if(foodRequestFlag == 1){
                    self.situationText.text = "Food request has been sent"
                }
                else{
                    self.situationText.text = "Food request has not been sent"
                }
                let RequestAcceptFlag = patient!.objectForKey("RequestAcceptFlag") as! NSNumber
                if(RequestAcceptFlag == 1){
                    self.resultText.text = "Food request has been Accepted"
                }
                else{
                    self.resultText.text = "Food request has not been Accepted"
                }
                let patientPing = patient!.objectForKey("SelfPing") as! NSNumber
                let glucose = patient!.objectForKey("GlucoseLevel") as! NSNumber
                if((glucose as Int) < 75 ){
                    self.emergenceText.text = "The are some problems"
                }
                else{
                    self.emergenceText.text = "The patient's situation is good"
                }
                self.glucoseText.text = "Glucose level is: " + glucose.stringValue
                let insulin = patient!.objectForKey("InfuseInsulin") as! NSNumber
                self.insulinText.text = "Insulin level is: " + insulin.stringValue
                let glucocon = patient!.objectForKey("Glucocon") as! NSNumber
                self.glucoconText.text = "Glucagon level is: " + glucocon.stringValue
                let emgFlag = patient!.objectForKey("EmgFlag") as! NSNumber
                if(emgFlag == 1){
                    self.emergenceText.text = "The patient is hypoglycemic."
                }
                let restInsulin = patient!.objectForKey("RestInsulin") as! NSNumber
                if((restInsulin as Int) < 5){
                    self.restInsulin.text = "Need refilling insulin"
                }
                else{
                    self.restInsulin.text = "Insulin is sufficient"
                }
                var finish = NSDate()
                var timeFormatter = NSDateFormatter()
                timeFormatter.dateFormat = "ssSSS"//"yyy-MM-dd 'at' HH:mm:ss.SSS"
                let startInt = timeFormatter.stringFromDate(start).toInt()!
                let finishInt = timeFormatter.stringFromDate(finish).toInt()!
                let docPing = finishInt - startInt
                let strNowTime = docPing + (patientPing as Int)
                if(connectionCount > 0){
                    if(strNowTime < 1000){
                        var strNowTimeString = String(strNowTime)
                        self.PingValue.text = "Ping value: " + strNowTimeString + "ms"// + String((patientPing as Int))
                    }
                    else{
                        self.PingValue.text = "Poor network"
                    }
                }
                else{
                    self.PingValue.text = "Patient disconnected"
                }
                let connectionFlag = patient!.objectForKey("ConnecTestFlag") as! NSNumber//test connection
                if(connectionFlag == 1){//doctor puts 1
                    if(connectionCount >= 1){
                        connectionCount = connectionCount - 1
                    }
                }
                else if let patient = patient{
                    patient["ConnecTestFlag"] = 1
                    patient.saveInBackground()
                    connectionCount = 30
                }
                if let patient = patient{
                patient["DocPing"] = docPing as NSNumber
                    patient.saveInBackground()
                }
                
            } else {
                println(error)
            }
        }
        //sleep(1);
    }


}
