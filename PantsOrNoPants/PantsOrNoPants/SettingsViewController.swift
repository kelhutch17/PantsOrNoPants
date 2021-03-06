//
//  SettingsViewController.swift
//  PantsOrNoPants
//
//  Created by Kelly Hutchison on 7/17/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var tempToleranceFIeld: UISlider!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    
    var languageCode:NSString! = "en"
    
    let stepValue: Float = 1.0

    var currentLocation: CLLocation!
    var coord: CLLocationCoordinate2D!      // coord.latitude, coord.longitude
    var city: NSString!
    var manager: OneShotLocationManager?
    var error:NSError?
    
    //var manager: OneShotLocationManager?
    let requestHandler = RequestHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ageField.layer.borderColor = UIColor.lightGrayColor().CGColor
//        weightField.layer.borderColor = UIColor.lightGrayColor().CGColor
//        heightField.layer.borderColor = UIColor.lightGrayColor().CGColor
//
//        ageField.borderStyle = UITextBorderStyle.Line
//        weightField.borderStyle = UITextBorderStyle.Line
//        heightField.borderStyle = UITextBorderStyle.Line
        
//        ageField = UITextField(frame: CGRectMake(ageField.frame.origin.x, ageField.frame.origin.y, ageField.bounds.width, 40.0))
//        weightField = UITextField(frame:CGRectMake(weightField.frame.origin.x, weightField.frame.origin.y, weightField.bounds.width, 40.0))
//        heightField = UITextField(frame: CGRectMake(heightField.frame.origin.x, heightField.frame.origin.y, heightField.bounds.width, 40.0))
    }
    
    // Implement snapping for the slider
    @IBAction func ittChange(sender: AnyObject) {
        print(tempToleranceFIeld.value)
        
        let newStep = roundf((tempToleranceFIeld.value) / stepValue);
        
        // Convert "steps" back to the context of the sliders values.
        self.tempToleranceFIeld.value = newStep * self.stepValue;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchCurrentLocation()
        if let err:NSError = self.error {
            // Error is not nil - handle the issue
        } else {
            // Error is still nil - proceed with business logic
            if let loc:CLLocationCoordinate2D = self.coord {
                //self.coord = loc
                self.city = getCityNameFromCoord(loc)
            }
        }
    }
    

//    @IBAction func segmentedCtrlChanged(sender: AnyObject) {
//    }
//    
//    @IBAction func languageChanged(sender: AnyObject) {
//        if let sc:UISegmentedControl = sender as? UISegmentedControl
//        {
//            switch sc.selectedSegmentIndex
//            {
//            case 0:
//                languageCode = "en"
//            case 1:
//                languageCode = "es"
//            case 2:
//                languageCode = "it"
//            default:
//                languageCode = "en"
//            }
//        }
//    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {
        var error: NSError?
        var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        print(dict)
        print("Going to pants view")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var pantsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("pantsView") as PantsViewController
        self.presentViewController(pantsViewController, animated: true, completion: nil)
    }
    
    /*
     * Make a network call to submit user settings
     */
    @IBAction func submitSettings(sender: AnyObject) {
        let session = NSUserDefaults.standardUserDefaults()
        
        var userid = ""
        var apikey = ""
        if let id = session.stringForKey("id") {
            userid = id
        }
        if let key = session.stringForKey("apikey") {
            apikey = key
        }
        if userid.isEmpty || apikey.isEmpty {
            NSLog("Invalid username or apikey")
            return
        }
        
        var params: Dictionary = ["apikey": apikey]//, "home_lat": 37.37, "home_lng": -122.04]
        
        if !ageField.text.isEmpty {
            params["age"] = ageField.text
        }
        if !heightField.text.isEmpty {
            params["height"] = heightField.text
        }
        if !weightField.text.isEmpty {
            params["weight"] = weightField.text
        }
        
//        params["gender"] = sexSegmentedCtrl.selectedSegmentIndex.description
        
//        if let lc:NSString = languageCode {
//            params["lang"] = lc as String
//        }
//        var inclination = getInclinationText(tempToleranceFIeld.value)
//        if !inclination.isEmpty {
//            params["inclination"] = inclination
//        }
        
        requestHandler.sendRequest("http://pants.guru:5000/api/v1/users/" + userid, method: "PUT", params: params, completionHandler: handler)
    }
    
    // Map inclination value to text
    func getInclinationText(val: Float) -> String {
        return val == 1 ? "warmer": (val == 0 ? "neutral": "cooler")
    }
    
    func fetchCurrentLocation() {
        //
        // request the current location
        //
        self.manager = OneShotLocationManager()
        
        self.manager!.fetchWithCompletion { location, error in
            // fetch location or an error
            if let loc = location {
                self.coord = loc.coordinate
                self.error = nil
            } else if let err = error {
                self.coord = nil
                self.error = err
            }
            
            // destroy the object immediately to save memory
            self.manager = nil
        }
    }
    
    func getCityNameFromCoord(coord: CLLocationCoordinate2D) -> NSString {
        // TODO add server call to get city name from coord
        return "Happy Valley"
    }
}