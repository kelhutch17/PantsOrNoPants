//
//  RequestHandler.swift
//  PantsOrNoPants
//
//  Created by Mike Wang on 7/18/15.
//  Copyright (c) 2015 HackDay. All rights reserved.
//

import Foundation

class RequestHandler {

    func sendRequest(url: String, completionHandler handler: (NSURLResponse!, NSData!, NSError!) -> Void) {
        let requestUrl = NSURL(string: url)
        let request = NSURLRequest(URL: requestUrl!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: handler)
    }
    
//    func sendRequest(url: String, parameters: [String: AnyObject],
//        completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) {
//        let parameterString = parameters.stringFromHttpParameters()
//        let url = NSURL(string:"\(url)?\(parameterString)")!
//        
//        var request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "GET"
//        
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request, completionHandler:completionHandler)
//        task.resume()
//    }

}

extension String {
    
    /// Percent escape value to be added to a URL query value as specified in RFC 3986
    ///
    /// This percent-escapes all characters besize the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Return precent escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = map(self) { (key, value) -> String in
            let percentEscapedKey = (key as String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return join("&", parameterArray)
    }
    
}