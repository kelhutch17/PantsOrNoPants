//
//  SignUpViewController.swift
//  PantsOrNoPants
//
//  Created by Kelly Hutchison on 7/17/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let requestHandler = RequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.secureTextEntry = true
    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {
        var error: NSError?
        var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        print("Saving user session")
        print(dict)

        let session = NSUserDefaults.standardUserDefaults()
        session.setObject(fullNameField.text!, forKey: "fullname")
        session.setObject(dict["username"], forKey: "username")
        session.setObject(dict["password"], forKey: "password")
        session.setObject(dict["apikey"], forKey: "apikey")
        session.setObject(dict["id"], forKey: "id")

        print("Changing view to settings")
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var settingsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("settingsView") as SettingsViewController
        self.presentViewController(settingsViewController, animated: true, completion: nil)
    }
    
    @IBAction func signupSubmit(sender: AnyObject) {
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty || fullNameField.text!.isEmpty {
            NSLog("Name and password cannot be empty")
            return
        }
        
        var params = ["username": usernameField.text!, "password": passwordField.text!]
        requestHandler.sendRequest("http://pants.guru:5000/api/v1/users", method: "POST", params: params, completionHandler: handler)
    }
}
