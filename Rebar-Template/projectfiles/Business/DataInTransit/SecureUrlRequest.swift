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

typealias SecureUrlRequestFinished = (SecureUrlRequest) -> ();

open class SecureUrlRequest : NSObject, URLSessionDelegate {
    
    override init() {
        super.init()
    }
    
    /**
     Headers from the HTTP Request
     */
    public var requestHeaders: [String:String]? = nil
    
    /**
     Headers from the HTTP Response
     */
    public var responseHeaders: [String:String] = [:]
    
    /**
     HTTP Status Code result
     */
    public var httpCode: Int? = nil
    
    /**
     Stores any relevant error
     */
    public var error: Error?
    
    /**
     Indicates if the request was canceled
     */
    public var wasCanceled: Bool = false
    
    /**
     Retrieves the data if applicable for the response
     */
    public var responseData: Data? = nil
    
    /**
     Local object so we don't process the JSON multiple times
     */
    private var _responseJsonAsDictonary: [String : Any]? = nil
    
    /**
     Determines if the content type was JSON
     */
    public var wasJsonResponse: Bool {
        if let contentType = self.responseHeaders["Content-Type"] {
            return contentType.starts(with: "application/json")
        }
        return false
    }
    
    /**
     Retrieves the Response Data as a dictionary
     */
    public var responseJsonAsDictonary: [String : Any]? {
        
        // Safety 
        guard self.wasJsonResponse else {
            return nil
        }
        
        // Safety first
        guard _responseJsonAsDictonary != nil else {
            return _responseJsonAsDictonary
        }
        
        // Parse out the data
        if let responseData = self.responseData {
            let json = JSON(data: responseData)
            if json != nil {
                self._responseJsonAsDictonary = json.dictionaryObject! as [String : Any]
                return self._responseJsonAsDictonary
            }
        }
        return nil
    }
    
    /**
     The URL Connection to the service
     */
    fileprivate var connection: URLSession?
    
    /**
     The URL we are accessing
     */
    fileprivate var requestUrl: URL? = nil
    
    /**
     Task the request is made with
     */
    fileprivate var dataTask: URLSessionDataTask? = nil
    
    /**
     Access to the underlying HTTP Request
     */
    fileprivate var request: NSMutableURLRequest? = nil
    
    
    /**
     Updates the headers locally when they come back from the server (if the WSBT have expired)
     
     You may issue the headers differently with diffrent names, so mind the names.
     */
    func storeRefreshHeaders(forService service: String) {
        let headers = self.responseHeaders
        if headers["refresh-authkeyrefid"] != nil {
            let shared = headers["refresh-authkeyrefid"]!
            let secret = headers["refresh-secretkey"]!
            RebarUtil.default.setWebServiceApiKeys(service: service, publicKey: shared, secretKey: secret)
        }
        
    }
    
    /**
     Pulls the output from the response into this request so we can expose
     them to the invoking method
     */
    fileprivate func wrapup(_ data: Data?, response: HTTPURLResponse?) {
        
        self.httpCode = response!.statusCode;
        
        // Clear headers
        self.responseHeaders.removeAll()

        // Configure the headers
        for (key,value) in response!.allHeaderFields {
            self.responseHeaders["\(key)"] = "\(value)";
        }
        
        if data != nil && data!.count > 0 {
            self.responseData = data;
        }
        else {
            self.responseData = nil
        }
        
    }
    
    /**
     Starts the request to the server and calls the finished block when done
    */
    func start(finished: SecureUrlRequestFinished? = nil) {
        DispatchQueue.global(qos: .background).async {
            
            [weak self] in
            guard let self = self else { return }
            
            self.connection = URLSession(
                configuration: URLSessionConfiguration.ephemeral,
                delegate: nil,
                delegateQueue: nil)
            
            self.dataTask = self.connection!.dataTask(with: self.request! as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
                guard let self = self else { return }
                
                // Handle an applicable error
                if error != nil {
                    // TODO: Comment this out so you aren't printing stuff in production
                    print("error: \(error!.localizedDescription): \(error!)")
                    self.error = error;
                    
                    if response != nil {
                        self.httpCode = (response as! HTTPURLResponse).statusCode;
                    }
                    else {
                        self.httpCode = 500;
                    }
                    
                }
                else {
                    self.wrapup(data, response: response as? HTTPURLResponse);
                }
                
                // Finished, handle off in async manner
                DispatchQueue.main.async {
                    finished?(self);
                }
                
            });
            
            // Start the request
            self.dataTask?.resume();

        }
        
    }
    
    /**
     Cancels the request currently in process
     */
    func cancel() {
        if let localConnection = self.dataTask {
            self.wasCanceled = true
            localConnection.cancel();
            self.dataTask = nil
        }
    }
    
    /**
     Performs a HTTP DELETE operaton
     */
    func delete(_ url: String, contentType: String? = nil, headers: [String:String]? = nil, data: Data? = nil) -> SecureUrlRequest {
        return send(url, method: "DELETE", contentType: contentType, headers: headers, data: data)
    }
    
    /**
     Performs a HTTP PUT operaton
     */
    func put(_ url: String, contentType: String? = nil, headers: [String:String]? = nil, data: Data? = nil) -> SecureUrlRequest {
        return send(url, method: "PUT", contentType: contentType, headers: headers, data: data)
    }
    
    /**
     Performs a HTTP POST operaton
     */
    func post(_ url: String, contentType: String? = nil, headers: [String:String]? = nil, data: Data? = nil) -> SecureUrlRequest {
        return send(url, method: "POST", contentType: contentType, headers: headers, data: data)
    }
    
    /**
     Performs a HTTP GET operaton
     */
    func get(_ url: String, headers: [String:String]? = nil) -> SecureUrlRequest {
        return send(url, method: "GET", contentType: nil, headers: headers)
    }
    
    /**
     Sends the data to the server

     - parameter url: the url we are calling
     - parameter host: the host we are calling
     - parameter method: the HTTP Method we are invoking
     - parameter contentType: the content type we are sending to the server
     - parameter headers: the headers to send to the server
     - parameter data: the data to send to the server
     - parameter finishedCallback: The callback to invoke after the request completes
     */
    fileprivate func send(_ url: String, method: String = "GET", contentType: String? = nil, headers: [String:String]? = nil, data: Data? = nil) -> SecureUrlRequest {
        
        // This is the URL we will be calling
        self.requestUrl = URL(string: url)
        
        // Grab the host from the URL
        let requestedHost = self.requestUrl!.host!
        
        if self.requestUrl == nil {
            preconditionFailure("Invalid HTTP host for url \(url)")
        }
        
        // We need to manipulate these
        var _headers = headers;

        // We are going to be adding fields to the headers so ensure that tehy are valid
        if _headers == nil {
            _headers = [:];
        }
        
        // Start building the request
        let request: NSMutableURLRequest! = NSMutableURLRequest(url: self.requestUrl!);

        // Set the HTTP method
        request.httpMethod = method;

        // Set values
        request.setValue(requestedHost, forHTTPHeaderField: "Host");
        if contentType != nil {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type");
        }

        // Copy over headers
        if (_headers != nil) {
            for (key,value) in _headers! {
                request.addValue(value, forHTTPHeaderField: key);
            }
        }

        // Copy over data to send to server
        if (data != nil && method.lowercased() != "get") {
            request.httpBody = data!;
            request.setValue("\(data!.count)", forHTTPHeaderField: "Content-Length");
        }
        
        // Store the request
        self.request = request;
        
        // Copy over
        self.requestHeaders = headers
                
        // Return yourself
        return self
                
    }
    
    
}
