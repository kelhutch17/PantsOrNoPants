//
//  PantsViewController.swift
//  PantsOrNoPants
//
//  Created by Kelly Hutchison on 7/17/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PantsViewController: UIViewController {
    
    var currentLocation: CLLocation!
    var coord: CLLocationCoordinate2D!      // coord.latitude, coord.longitude
    
    var manager: OneShotLocationManager?
    let requestHandler = RequestHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("getPantsData"), userInfo: nil, repeats: true)
    }
    
    func getPantsData() {
        let session = NSUserDefaults.standardUserDefaults()
        if let key = session.stringForKey("apikey") {
            let params = ["apikey": key, "lat": "30.4", "lng": "40"]
            requestHandler.sendRequest("http://pants.guru:5000/api/v1/pants", method: "GET", params: params, completionHandler: handler)
        }

    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {
        var error: NSError?
        var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        
//        print("Saving user session")
//        let session = NSUserDefaults.standardUserDefaults()
//        session.setObject(usernameField.text, forKey: "username")
//        session.setObject(passwordField.text, forKey: "password")
//        
//        print(dict)
//        print("Changing view to settings")
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        var settingsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("settingsView") as SettingsViewController
//        self.presentViewController(settingsViewController, animated: true, completion: nil)
    }

    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        var locationErrorTuple:(CLLocationCoordinate2D?, NSError?)? = fetchCurrentLocation()
        if let err:NSError = locationErrorTuple!.1
        {
            // Error is not nil - handle the issue
        }
        else
        {
            // Error is still nil - proceed with business logic
            if let loc: CLLocationCoordinate2D = locationErrorTuple!.0
            {
                self.coord = loc
            }
        }
    }
    
//    func createStar(num: Int) {
//        var arrayOfImageViews = [];
//        for (int i = 0; i < num; i++) {
//            let imageView = UIImageView(image: UIImage(named: "star" + i))
//            self.view.addSubview(imageView)
//            
//            arrayOfImageViews.insert(imageView)
//        }
//        return arrayOfImageViews
//    }
    
    func fetchCurrentLocation()->(CLLocationCoordinate2D?, NSError?)? {
        //
        // request the current location
        //
        manager = OneShotLocationManager()
        var coord: CLLocationCoordinate2D!
        var returnedError: NSError!
        
        manager!.fetchWithCompletion { location, error in
            // fetch location or an error
            if let loc:CLLocation = location {
                coord = loc.coordinate
            } else if let err = error {
                coord = nil
                returnedError = err
            }
            
            // destroy the object immediately to save memory
            self.manager = nil
        }
        return (coord, returnedError);
    }
}