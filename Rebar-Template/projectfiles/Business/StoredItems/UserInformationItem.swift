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

import Foundation
import Rebar

class UserInformationItem : AppItem {
	
	var text: String?;
    
    
    /**
     Creates a new RecallItem from the dictionary
     */
    public static func from(dictionary: [String:Any]) -> UserInformationItem {
        let item = UserInformationItem()
        
        if let _val = dictionary["text"] as? String {
            item.text = _val
        }
        
        return item
    }
    
    /**
     This object as a JSON object
     */
    public var asDictionary: [String:Any] {
        // This will house our data for this as a JSON object
        var toReturn: [String:Any] = [:]
        
        if let val = text {
            toReturn["text"] = val
        }
        
        return toReturn
    }
    
    
    /**
     Creates an event from JSON
     */
    public static func from(json: String) -> UserInformationItem {
        
        
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
