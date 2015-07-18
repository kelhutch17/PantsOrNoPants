//
//  SignUpViewController.swift
//  PantsOrNoPants
//
//  Created by Kelly Hutchison on 7/17/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let requestHandler = RequestHandler()
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {

    }
    
    @IBAction func signupSubmit(sender: AnyObject) {
        requestHandler.sendRequest("hi", handler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
