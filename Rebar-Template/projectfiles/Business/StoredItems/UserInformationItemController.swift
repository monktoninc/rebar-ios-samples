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

class UserInformationItemController : AppItemController<UserInformationItem> {
	
	
	override func getDatabase() -> FMDatabaseQueue? {
		return RebarDatabaseManager.default.getDatabase(RebarAppDatabase.self);
	}
	
	override fileprivate init() {
		// No one should instantiate these classes but us
	}
	
	// Token for the once call
	static var token: Int = 0
	static var instance: UserInformationItemController = UserInformationItemController();
	
	// Grabs the instance of the App Controller
	static func getInstance() -> UserInformationItemController! {
		return instance;
	}
	

	/// Parses and stores raw data from the service
	override func parseAndStore(_ items: [String:AnyObject]) {
		
		// Parse the items
		let parsed: [UserInformationItem] = UserInformationParser.parseItems(items)!;
		
		// Store the items
		store(parsed);
		
	}
	

	/// Adds an item to the database
	override func add(_ item: UserInformationItem, database: FMDatabase!) {
		
		let vals: RebarDatabaseValues = RebarDatabaseValues();
		
		vals.putString("ITEM_REF_ID", value:item.itemRefId);
		vals.putString("ITEM_TEXT", value:item.text);
		
		// Insert query
		let query: String = "INSERT INTO REBAR_APP_ITEM ( ITEM_REF_ID , ITEM_TEXT ) VALUES ( :ITEM_REF_ID , :ITEM_TEXT )";
		
		// Add the item
		item.itemId = RebarDatabase.executeInsert(vals, query: query, table: "REBAR_APP_ITEM", column: "ITEM_ID", database: database);
		
	}
	

	/// updates an item in the database
	override func update(_ item: UserInformationItem, database: FMDatabase!) {
		
		let vals: RebarDatabaseValues = RebarDatabaseValues();
		
		vals.putString("ITEM_REF_ID", value:item.itemRefId);
		vals.putString("ITEM_TEXT", value:item.text);
		

		// Insert query
		let query: String = "UPDATE REBAR_APP_ITEM SET ITEM_TEXT = :ITEM_TEXT WHERE ITEM_REF_ID = :ITEM_REF_ID";
		
		RebarDatabase.executeUpdate(vals, query: query, database: database);
		
	}
	

	/// Deletes an item from the database
	override func delete(_ itemId: Int, database: FMDatabase!) {
		
		let vals: RebarDatabaseValues = RebarDatabaseValues();
		
		// Set the item to delete
		vals.putInt("ITEM_ID", value:itemId);
		
		// Insert query
		let query = "DELETE FROM REBAR_APP_ITEM WHERE ITEM_ID = :ITEM_ID";
		
		RebarDatabase.executeUpdate(vals, query: query, database: database);
		
	}
	

	/// Reads an item from the database
	override func read(_ resultSet: FMResultSet) -> UserInformationItem? {
		
		let data = UserInformationItem();
		
		data.itemRefId = resultSet.readString("ITEM_REF_ID");
		data.itemId = resultSet.readInt("ITEM_ID");
		data.text = resultSet.readString("ITEM_TEXT");
		
		return data;
		
	}
	
	

	/// Retrieves all the items from the database
	override func getAll() -> [UserInformationItem] {
		
		let query = "SELECT * FROM REBAR_APP_ITEM ORDER BY ITEM_TEXT DESC";
		
		var items: [UserInformationItem]? = nil;
		
		getDatabase()?.inDatabase({ (database: FMDatabase!) -> Void in
			items = RebarDatabase.executeQuery(query, database: database, reader: {(reader: FMResultSet) -> AnyObject in
				return self.read(reader)!;
			});
		});
		
		return items!;
	}
	

	/// Get an item id
	override func getItemId(_ refId: String!, database: FMDatabase) -> Int {
		return RebarCoreBO.readInteger("SELECT ITEM_ID FROM REBAR_APP_ITEM WHERE ITEM_REF_ID = '\(refId!)'", columnName: "ITEM_ID", database: database);
	}
	
	

	/// Retrieves a single item
	override func get(_ refId: String!) -> UserInformationItem? {
		var item: UserInformationItem?;
		getDatabase()?.inDatabase({ (database: FMDatabase!) -> Void in
			let itemId = self.getItemId(refId, database: database);
			item = self.get(itemId, database: database);
		});
		return item;
	}
	

	/// Retrieves a single item
	override func get(_ refId: String!, database: FMDatabase) -> UserInformationItem? {
		let itemId = getItemId(refId, database: database);
		return get(itemId, database: database);
	}
	

	/// Retrieves a single item
	override func get(_ itemId: Int) -> UserInformationItem? {
		var item: UserInformationItem?;
		getDatabase()?.inDatabase({ (database: FMDatabase!) -> Void in
			item = self.get(itemId, database: database);
		});
		return item;
	}
	
	/// Retrieves a single item
	override func get(_ itemId: Int, database: FMDatabase) -> UserInformationItem? {
		let query = "SELECT * FROM REBAR_APP_ITEM WHERE ITEM_ID = '\(itemId)'"
		let items: [UserInformationItem] = RebarDatabase.executeQuery(query, database: database, reader: {(reader: FMResultSet) -> AnyObject in
			return self.read(reader)!;
		});
		if (items.count == 1) {
			return items[0];
		}
		return nil;
	}
	
	
}
