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

class RebarAppSettingsViewController : RebarCoreViewController, UITableViewDataSource, UITableViewDelegate {
	
	static let AppSettingCellIdentifier: String! = "AppSettingCell";
	var RowTitles: [[RebarAppSettingAction]]? = nil;
	
	
	@IBOutlet var settingsTableView: UITableView!
	@IBOutlet var logoffBarButtonItem: UIBarButtonItem!
	
	override func loadView() {
		super.loadView();
        
        self.tabBarItem.image = UIImage(named: "GearIcon");
		
		
		if !RebarAppController.default.shouldShowChangePasscodeScreen() {
			
			RowTitles = [
				[
					RebarAppSettingAction(title: "Privacy Policy") {
						self.navigationController?.pushViewController(RebarPrivacyViewController(), animated: true);
					},
					RebarAppSettingAction(title: "Legal") {
						self.navigationController?.pushViewController(RebarLegalViewController(), animated: true);
					}				],
			];
		}
		else {
			
			RowTitles = [
				[
					RebarAppSettingAction(title: "Passcode Settings") {
						RebarAppController.default.showChangePasscodeScreen(self.navigationController!);
					},
				],
				[
					RebarAppSettingAction(title: "Privacy Policy") {
						self.navigationController?.pushViewController(RebarPrivacyViewController(), animated: true);
					},
					RebarAppSettingAction(title: "Legal") {
						self.navigationController?.pushViewController(RebarLegalViewController(), animated: true);
					}
				],
			];
		}
        
        // Register the handler class
        self.settingsTableView.register(UINib(nibName: "RebarAppSettingsTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "RebarAppSettingsTableViewCell");
		
		// Scrolling header hide
		self.settingsTableView.addScrollingHideView();
		
		self.settingsTableView.dataSource = self;
		self.settingsTableView.delegate = self;
		self.settingsTableView.allowsSelection = true;
		self.settingsTableView.allowsSelectionDuringEditing = true;
		
		self.settingsTableView.sectionFooterHeight = 0;
		self.settingsTableView.sectionHeaderHeight = 0;
		
		self.settingsTableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0);
		
	}
    
	@IBAction func logoffBarButtonItemTapped(_ sender: AnyObject) {
		showLogoffAlert();
	}
	
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44.0;
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0;
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 48;
	}
	
	func numberOfSections(in tableView: UITableView) -> Int  {
		return RowTitles!.count + 1;
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RowTitles!.count == section {
            return 1;
        }
		return RowTitles![section].count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if RowTitles!.count == indexPath.section {
            
            let cell = UITableViewCell();
            
            cell.textLabel?.text = "Log Off";
            cell.textLabel?.textColor = UIColor.red;
            cell.textLabel?.textAlignment = .center;
            
            return cell;
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RebarAppSettingsTableViewCell", for: indexPath) as! RebarAppSettingsTableViewCell
            
            let options = RowTitles![indexPath.section][indexPath.row];
            
            cell.appSettingNameLabel.text = options.title;
            
            return cell
            
        }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true);
        
        if indexPath.section == RowTitles!.count {
            self.showLogoffAlert();
        }
        else {
            RowTitles![indexPath.section][indexPath.row].action();
        }
		
	}
}
