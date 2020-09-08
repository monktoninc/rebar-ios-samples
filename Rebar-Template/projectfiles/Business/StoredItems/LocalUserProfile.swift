/// The MIT License (MIT)
///
/// Copyright (c) 2016 Monkton, Inc
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///

import Rebar

public class LocalUserProfile {
    
    /**
     Defines the user name
     */
    public var name: String?
    
    
    public var accountEmail: String?
    public var accountRefId: String?
    
    public var hasProfileSet: Bool = false
    
    
    /**
     Creates a new RecallItem from the dictionary
     */
    public static func from(dictionary: [String:Any]) -> LocalUserProfile {
        let item = LocalUserProfile()
        
        if let _val = dictionary["name"] as? String {
            item.name = _val
        }
        if let _val = dictionary["accountRefId"] as? String {
            item.accountRefId = _val
        }
        if let _val = dictionary["accountEmail"] as? String {
            item.accountEmail = _val
        }
        if let _val = dictionary["hasProfileSet"] as? Bool {
            item.hasProfileSet = _val
        }
        
        return item
    }
    
    /**
     This object as a JSON object
     */
    public var asDictionary: [String:Any] {
        // This will house our data for this as a JSON object
        var toReturn: [String:Any] = [:]
        
        toReturn["hasProfileSet"] = hasProfileSet
        
        if let name = name {
            toReturn["name"] = name
        }
        if let accountEmail = accountEmail {
            toReturn["accountEmail"] = accountEmail
        }
        if let accountRefId = accountRefId {
            toReturn["accountRefId"] = accountRefId
        }
        
        return toReturn
    }
    
    
    /**
     Creates an event from JSON
     */
    public static func from(json: String) -> LocalUserProfile {
        
        
        if let dataFromString = json.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString);
            let dictionary: [String : AnyObject] = json.dictionaryObject! as [String : AnyObject];
            return from(dictionary: dictionary);
        }
        
        // Nope
        preconditionFailure("this should not happen...")
    }
    
    /**
     Retrieves the Json as a string object
     
     - Returns: a dictionary object composed of values representing this RecallItem
     */
    public var asJsonString: String {
        get {
            return JSON(asDictionary).rawString()!
        }
    }
    
    /**
     Retrieves the object as a JSON object
     
     - Returns: a dictionary object composed of values representing this RecallItem
     */
    public var asJson: JSON {
        get {
            return JSON(asDictionary)
        }
    }
}
