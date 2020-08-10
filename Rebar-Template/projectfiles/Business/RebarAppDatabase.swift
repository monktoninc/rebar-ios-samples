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
import RebarSupport

class RebarAppDatabase : RebarDatabase {
	
	/// The name of the database
    override var databaseName: String {
        return "demo-app.sqlite";
    }
	
	static let APP_NAME: String = "RebarAppDatabase";
	
	// Check u"pgrades
	override func verifyUpgrades(_ db: FMDatabase!) {
		
		
		super.verifyUpgrades(db);
		
		var currentVersion: Int = self.getCurrentDatabaseVersion(db, app: RebarAppDatabase.APP_NAME);
		
		if (currentVersion < 2) {
			
			performSingleUpgrade("CREATE TABLE [REBAR_APP_ITEM] (ITEM_ID INTEGER PRIMARY KEY AUTOINCREMENT, ITEM_REF_ID TEXT , ITEM_TEXT TEXT )", db: db);
			
			
			currentVersion = 2;
			
			setCurrentDatabaseVersion(db, app: RebarAppDatabase.APP_NAME, version: currentVersion);
			
		}
		
	}
	
}
