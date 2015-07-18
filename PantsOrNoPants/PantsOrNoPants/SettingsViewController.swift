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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var locationErrorTuple:(CLLocationCoordinate2D?, NSError?)? = fetchCurrentLocation()
        if let err:NSError = locationErrorTuple!.1 {
            // Error is not nil - handle the issue
        } else {
            // Error is still nil - proceed with business logic
            if let loc:CLLocationCoordinate2D = locationErrorTuple!.0 {
                self.coord = loc
                self.city = getCityNameFromCoord(loc)
            }
        }
    }
    
    @IBAction func changeAgeField(sender: AnyObject) {
        ageField.text = sender.value
    }
    

    @IBAction func submitSettings(sender: AnyObject) {
        
    }
    
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
    
    func getCityNameFromCoord(coord: CLLocationCoordinate2D) -> NSString {
        // TODO add server call to get city name from coord
        return "Happy Valley"
    }
}