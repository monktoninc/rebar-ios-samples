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
import RebarSupport
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AppItemController<T: AppItem> {
	
	func getDatabase() -> FMDatabaseQueue? {
		preconditionFailure("You must define a database");
	}
	
	/**
	* Parses and stores raw data from the service
	*/
	func parseAndStore(_ items: [String:AnyObject]) {
		
	}
	
	/**
	* Stores a set of items in the database
	*/
	func store(_ items: [T]) {
		
		getDatabase()?.inDatabase({ (database: FMDatabase!) -> Void in
			for item in items {
				self.sync(item, database: database);
			}
		});
	}
	
	/**
	* Process an item to store into the database
	*/
	func sync(_ item: T, database: FMDatabase!) {
		
		// Grab the item id
		item.itemId = self.getItemId(item.itemRefId, database: database);
		
		// Save now
		self.commit(item, database: database);
	}
	
	/**
	* Commits a possibly identified item to the database
	*/
	func commit(_ item: T, database: FMDatabase!) {
		if (item.deleted != nil && item.deleted!) {
			delete(item, database: database);
		}
		else if (item.itemId > 0) {
			update(item, database: database);
		}
		else {
			add(item, database: database);
		}
	}
	
	/**
	* Adds an item to the database
	*/
	func add(_ item: T, database: FMDatabase!) {
		
	}
	
	/**
	* updates an item in the database
	*/
	func update(_ item: T, database: FMDatabase!) {
		
	}
	
	/**
	* Deletes an item from the database
	*/
	func delete(_ item: T, database: FMDatabase!) {
		delete(item.itemId!, database: database);
	}
	
	/**
	* Deletes an item from the database
	*/
	func delete(_ itemRefId: String, database: FMDatabase!) {
		delete(getItemId(itemRefId, database: database), database: database);
	}
	
	func delete(_ itemId: Int, database: FMDatabase!) {
		
	}
	
	/**
	* Reads an item from the database
	*/
	func read(_ resultSet: FMResultSet) -> T? {
		return nil;
	}
	
	
	/**
	* Retrieves all the items from the database
	*/
	func getAll() -> [T] {
		return [];
	}
	
	/**
	* Get an item id
	*/
	func getItemId(_ refId: String!, database: FMDatabase) -> Int {
		return -1;
	}
	
	/**
	* Retrieves a single item
	*/
	func get(_ refId: String!) -> T? {
		return nil;
	}
	
	/**
	* Retrieves a single item
	*/
	func get(_ refId: String!, database: FMDatabase) -> T? {
		return nil;
	}
	
	/**
	* Retrieves a single item
	*/
	func get(_ itemId: Int) -> T? {
		return nil;
	}
	
	/**
	* Retrieves a single item
	*/
	func get(_ itemId: Int, database: FMDatabase) -> T? {
		return nil;
	}

	
}
