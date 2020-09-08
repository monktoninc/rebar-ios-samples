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
import RebarSupport
import Rebar

class AccountModel {
    
    /**
     Defines the url invoker
     */
    fileprivate var urlRequest: SecureUrlRequest? = nil
    
    /**
     Retrieves the account from the server
     */
    func getAccount(completed: ((LocalUserProfile?) -> ())?) -> Bool {
        
        guard self.urlRequest == nil else {
            return false
        }
        
        // Setup our HTTP Method
        self.urlRequest = SecureUrlRequest()
        
        // Make the request to the server
        self.urlRequest?
            .get("https://\(AppUtil.default.apiHost)/account")
            .start() {
                [weak self] (result) in
                guard let self = self else { return }
                
                // Cleanup
                self.urlRequest = nil
            
                // If we have updated refresh tokens for the web service, store them here
                result.storeRefreshHeaders(forService: AppUtil.default.serviceName)
                
                // Check the response
                if let resultDictionary = result.responseJsonAsDictonary {
                    let profile = LocalUserProfile.from(dictionary: resultDictionary)
                    completed?(profile)
                }
                else {
                    completed?(nil)
                }
                
        }
        
        
        return true
    }
    
    
    /**
     Generates the API tokens to interact direclty with Rebar
     */
    public func generateApiTokens(completed: @escaping (Bool) -> ()) -> Bool {
        
        guard self.urlRequest == nil else {
            return false
        }
        let url = "https://\(AppUtil.default.apiHost)/api/v1/app/token"
        
        // Setup our HTTP Method
        self.urlRequest = SecureUrlRequest()
        
        // Make the request to the server
        self.urlRequest?.get(url).start() {
            [weak self] (result) in
            guard let self = self else { return }
            
            // Cleanup
            self.urlRequest = nil
        
            // If we have updated refresh tokens for the web service, store them here
            result.storeRefreshHeaders(forService: AppUtil.default.serviceName)
            

            if result.httpCode != 200 {
                if result.responseData != nil {
                    print(String(data: result.responseData!, encoding: .utf8)!)
                }
                completed(false)
            }
            else {

                // Check the response
                if let resultDictionary = result.responseJsonAsDictonary, resultDictionary["authKeyRefId"] != nil {
                    
                    // Grab the keys we will store
                    let sharedKey = resultDictionary["authKeyRefId"] as! String
                    let secretKey = resultDictionary["secretKey"] as! String

                    // Store these values
                    RebarUtil.default.setWebServiceApiKeys(service: AppUtil.default.serviceName, publicKey: sharedKey, secretKey: secretKey)
                    
                    completed(true)
                    
                }
                else {
                    completed(false)
                }
                
            }
                
        }
        
        return true
        
    }
    
    
}
