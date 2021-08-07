//
//  SQLDB.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/7/21.
//

import Foundation
import SQLite

class SQLDB {
    static let share = SQLDB()
    var data_base: Connection?
    
    private init() {
        
        do {
            // create connection to db
            let doc_directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let file_url = doc_directory.appendingPathComponent("contactList").appendingPathExtension("sqlite3")
            data_base = try Connection(file_url.path)
        } catch {
            print("Error creating connectiopn to Database: \(error.localizedDescription)")
        }
    }
    
    // create DB table
    func create_db_table() {
        
    }
}
