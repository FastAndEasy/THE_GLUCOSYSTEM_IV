//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
var connectionCount: Int = 10;
class ViewController: UIViewController {
    var timer:NSTimer!
    @IBAction func refresh(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId("ofeFERPC8s") {
            (patient: PFObject?, error: NSError?) -> Void in
            if error == nil && patient != nil {
                //println(gameScore2)
                let foodRequestFlag = patient!.objectForKey("FoodRequestFlag") as! NSNumber
                if(foodRequestFlag == 1){
                    self.TextView.text = "Food request has been sent"
                }
                else{
                self.TextView.text = "Food request has not been sent"
                }
            } else {
                println(error)
            }
        }
    }
    @IBAction func callingDoctor(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId("ofeFERPC8s") {
            (patientChange: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let patientChange = patientChange {
                patientChange["EmgFlag"] = 1
                patientChange.saveInBackground()
            }
        }
    }
    @IBAction func button(sender: AnyObject) {
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId("ofeFERPC8s") {
            (patientChange: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let patientChange = patientChange {
                patientChange["FoodRequestFlag"] = 1
                patientChange.saveInBackground()
            }
        }

        /*
        var query = PFQuery(className:"Bulb")
        query.getObjectInBackgroundWithId("mSSqGm9Ot0") {
        (bulb: PFObject?, error: NSError?) -> Void in
        if error == nil && bulb != nil {
        //println(gameScore2)
        let playerName = bulb!.objectForKey("Hour") as! NSNumber
        self.TextView.text = playerName.stringValue
        } else {
        println(error)
        }
        }
        */
        
    }
    @IBOutlet weak var TextView: UITextView!
    
    @IBOutlet weak var PatientName: UITextField!
    @IBOutlet weak var CheckingTextView: UITextView!
    @IBOutlet weak var foodRequestpermit: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFQuery(className:"patient")
        query.getObjectInBackgroundWithId("ofeFERPC8s") {
            (patient: PFObject?, error: NSError?) -> Void in
            if error == nil && patient != nil {
                //println(gameScore2)
                let Name = patient!.objectForKey("Name") as! NSString
                self.PatientName.text = Name as String
            } else {
                println(error)
            }
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2,
            target:self,selector:Selector("checkingFoodRequestFlag"),
            userInfo:nil,repeats:true)
        //var gameScore2 = PFObject(className:"GameScore")
        /*
        var gameScore = PFObject(className:"GameScore3")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    */
    /*
        var query = PFQuery(className:"GameScore")
        query.getObjectInBackgroundWithId("Odk6nIeVvB") {
            (gameScore2: PFObject?, error: NSError?) -> Void in
            if error == nil && gameScore2 != nil {
                //println(gameScore2)
                 let playerName = gameScore2!.objectForKey("playerName") as! NSString
                self.TextView.text = playerName as String
            } else {
                println(error)
            }
        }
        */
        //let score = gameScore["score"] as! Int
        //let playerName = gameScore2["playerName"]as! String
        //let cheatMode = gameScore["cheatMode"]as! Bool
        // Do any additional setup after loading the view, typically from a nib.
    }
    func checkingFoodRequestFlag(){
            var start = NSDate()
            var query = PFQuery(className:"patient")
            query.getObjectInBackgroundWithId("ofeFERPC8s") {
                (patient: PFObject?, error: NSError?) -> Void in
                if error == nil && patient != nil {
                    let docPing = patient!.objectForKey("DocPing") as! NSNumber
                    let foodRequestEnableFlag = patient!.objectForKey("FoodRequestEnableFlag") as! NSNumber
                    if(foodRequestEnableFlag == 0){
                        self.foodRequestpermit.text = "Food Request not available now"
                    }
                    else{
                        self.foodRequestpermit.text = "Food Request is available now"
                    }
                    var finish = NSDate()
                    var timeFormatter = NSDateFormatter()
                    timeFormatter.dateFormat = "ssSSS"//"yyy-MM-dd 'at' HH:mm:ss.SSS"
                    let startInt = timeFormatter.stringFromDate(start).toInt()!
                    let finishInt = timeFormatter.stringFromDate(finish).toInt()!
                    let patientPing = finishInt - startInt
                    let strNowTime = patientPing + (docPing as Int)
                    var strNowTimeString = String(strNowTime)
                    if(connectionCount > 0){
                        self.CheckingTextView.text = strNowTimeString + "ms"
                    }
                    else{
                        self.CheckingTextView.text = "Doctor disconnected"
                    }
                } else {
                    println(error)
                }
                let connectionFlag = patient!.objectForKey("ConnecTestFlag") as! NSNumber//test connection
                if(connectionFlag == 0){//doctor puts 1
                    if(connectionCount >= 1){
                        connectionCount = connectionCount - 1
                    }
                }
                else if let patient = patient{
                    patient["ConnecTestFlag"] = 0
                    patient.saveInBackground()
                    connectionCount = 10
                }

            }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

