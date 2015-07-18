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
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var bmiField: UITextField!
    @IBOutlet weak var tempToleranceFIeld: UISlider!
    
    var currentLocation: CLLocation!
    var coord: CLLocationCoordinate2D!      // coord.latitude, coord.longitude
    var city: NSString!
    var manager: OneShotLocationManager?
    var error:NSError?
    
    //var manager: OneShotLocationManager?
    let requestHandler = RequestHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func changeAgeField(sender: AnyObject) {
        ageField.text = sender.value
    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {
        var error: NSError?
        var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        
        print(dict)
        print("Going to pants view")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var pantsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("pantsView") as! PantsViewController
        self.presentViewController(pantsViewController, animated: true, completion: nil)
    }
    
    /*
     * Make a network call to submit user settings
     */
    @IBAction func submitSettings(sender: AnyObject) {
        requestHandler.sendRequest("http://freegeoip.net/json/github.com", method: "GET", params: Dictionary<String, String>(), completionHandler: handler)
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
            
//            // destroy the object immediately to save memory
            self.manager = nil
        }
    }
    
    func getCityNameFromCoord(coord: CLLocationCoordinate2D) -> NSString {
        // TODO add server call to get city name from coord
        return "Happy Valley"
    }
}