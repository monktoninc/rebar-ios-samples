//
// Copyright (c) 2020, Monkton, Inc. CONFIDENTIAL. All Rights Reserved.
//
// NOTICE:  All information contained herein is, and remains the property of
// Monkton, Inc. and its suppliers, if any.  The intellectual and technical
// concepts contained herein are proprietary to Monkton, Inc. and its suppliers
// and may be covered by U.S. and Foreign Patents, patents in process, and are
// protected by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material is
// strictly forbidden unless prior written permission is obtained from
// Monkton, Inc.
//
// If this file is found, please contact security@monkton.io
//

import Rebar

public class AppUtil  {
    
    private init() {

    }
    
    /**
     Provides the utility class
    */
    public static var `default`: AppUtil = AppUtil();
    
    /**
     Retrieves the API Host for this sample app. This value is configured in the
     Rebar Hub
     */
    var apiHost: String {
        return RebarAppController.default.configuration.value(fromKey: "app.host")!
    }

    /**
     This is used to store our web service bearer tokens within the app when we use the Token
     service to connect to web services
     */
    var serviceName: String {
       return apiHost
    }
    
}
