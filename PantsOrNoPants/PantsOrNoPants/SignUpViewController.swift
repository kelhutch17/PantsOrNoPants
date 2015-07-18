//
//  SignUpViewController.swift
//  PantsOrNoPants
//
//  Created by Kelly Hutchison on 7/17/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let requestHandler = RequestHandler()
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {
        var error: NSError?
        var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        print("Saving user session")
        let session = NSUserDefaults.standardUserDefaults()
        session.setObject(usernameField.text, forKey: "username")
        session.setObject(passwordField.text, forKey: "password")
        
        print(dict)
        print("Changing view to settings")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var settingsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("settingsView") as SettingsViewController
        self.presentViewController(settingsViewController, animated: true, completion: nil)
    }
    
    @IBAction func signupSubmit(sender: AnyObject) {
        requestHandler.sendRequest("http://freegeoip.net/json/github.com", method: "GET", params: Dictionary<String, String>(), completionHandler: handler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
