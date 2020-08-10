///
/// Monkton, Inc CONFIDENTIAL
///
/// Copyright (c) 2016, Monkton, Inc CONFIDENTIAL
/// All Rights Reserved.
///
/// NOTICE:  All information contained herein is, and remains
/// the property of Monkton, Inc and its suppliers,
/// if any.  The intellectual and technical concepts contained
/// herein are proprietary to Monkton, Inc
/// and its suppliers and may be covered by U.S. and Foreign Patents,
/// patents in process, and are protected by trade secret or copyright law.
/// Dissemination of this information or reproduction of this material
/// is strictly forbidden unless prior written permission is obtained
/// from Monkton, Inc.
///


import UIKit
import Rebar
import RebarSupport

class RebarAppItemsViewController : RebarCoreViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet var fileTableView: UITableView!
	@IBOutlet var fileActionButton: UIBarButtonItem!
    
    var appSyncer: RebarAppSyncWrapper? = nil;
    var refreshDown = UIRefreshControl()
	
	static let AppSettingCellIdentifier: String! = "AppSettingCell";
	
	// All the items we will keep track of
	var currentItems: [UserInformationItem] = [];
	
	// Allows us to update the message "time stamps"
	var timer: Timer? = nil;
	
	
	@IBOutlet var allPatientsTableView: UITableView!
	
	// MARK: View Functions
	
	override func loadView() {
		super.loadView();
		
		var _x: UserInformationItem? = nil;
		
		_x = UserInformationItem();
		_x?.text = "Sample Item";
		currentItems.append(_x!);
		
		
		// Register thread views displaying data
		self.fileTableView.register(UINib(nibName: "RebarListItemTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "RebarListItemTableViewCell");
		
		// Scrolling header hide
		self.fileTableView.addScrollingHideView();
	
    }
    
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.fileTableView.reloadData();
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated);
	}
	
	/// Have the server check login
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated);
        
        
        
        
	}
	
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60;
	}
	
	func numberOfSections(in tableView: UITableView) -> Int  {
		return 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.currentItems.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RebarListItemTableViewCell", for: indexPath) as! RebarListItemTableViewCell
		
		//let _x = self.currentItems[indexPath.row];
		
		cell.formNameLabel.text = "ok";
		
        return cell;
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true);
	}
    
    /*
    Perform a sync action
    */
    @IBAction func syncButtonTapped(_ sender: AnyObject) {

        if self.appSyncer != nil {
            return;
        }
        
        self.appSyncer = RebarAppSyncWrapper();
        
        
        // Registration is complete now, cleanup
        self.appSyncer?.cleanupRequest = {
            self.appSyncer = nil;
        };
        
        // What to do when there is a successful request
        self.appSyncer?.successfulRequest = {(response: RebarSecureResponse!) in
            
            var json = response.getJson();
            
            // Grab data protection items
            let dataProtection = json!["say"].stringValue;
            
            let alertController = UIAlertController(title: "Survey Says", message: dataProtection, preferredStyle: .alert);
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action) in });
            
            self.present(alertController, animated: true) { };
            
        };
        
        // What to do when the request fails
        self.appSyncer?.failedRequest = {(response: RebarSecureResponse!, willLogoff: Bool) in
            if (willLogoff) {
                return;
            }
            response.apiError?.show(self);
        };
        
        self.appSyncer?.sync();
        
        
    }
}
