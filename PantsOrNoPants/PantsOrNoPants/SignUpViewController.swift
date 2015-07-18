//
//  SignUpViewController.swift
//  PantsOrNoPants
//
//  Created by Kelly Hutchison on 7/17/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let requestHandler = RequestHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.backgroundImage)
    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) {

    }
    
    @IBAction func signupSubmit(sender: AnyObject) {
        requestHandler.sendRequest("hi", completionHandler: handler)
    }
}
