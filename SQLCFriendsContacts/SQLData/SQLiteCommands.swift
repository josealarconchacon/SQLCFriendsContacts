//
//  SQLiteCommands.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/7/21.
//

import Foundation
import SQLite

class SQLiteCommand {
    static var set_table = Table("contact")
    
    // expression
    static let id = Expression<Int>("id")
    static let first_name = Expression<String>("first_name")
    static let last_name = Expression<String>("last_name")
    static let phone_number = Expression<Int>("phone_number")
    static let user_image = Expression<Data>("user_image")
    static let user_email = Expression<String>("user_email")
    
    // create table
    static func create_table() {
        guard let database = SQLDB.share.data_base else {
            print("Data connection error: ")
            return
        }
        do {
            // create table if Not Exists
            try database.run(set_table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(first_name)
                table.column(last_name)
                table.column(phone_number, unique: true)
                table.column(user_image)
                table.column(user_email)
            })
        } catch {
            print("Table already exists: \(error.localizedDescription)")
        }
    }
    
    // iNSERTING ROW
    static func insert_row(_ contact: UserContact) -> Bool? {
        guard let db = SQLDB.share.data_base  else {
            print("Data store connection error")
            return nil
        }
    }
}
