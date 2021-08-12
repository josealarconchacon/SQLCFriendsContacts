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
    static let phone_number = Expression<String>("phone_number")
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
    
    // inserting into row
    static func insert_row(_ contact: UserContact) -> Bool? {
        guard let db = SQLDB.share.data_base  else {
            print("Data store connection error")
            return nil
        }
        do {
            try db.run(set_table.insert(first_name <-   contact.first_name,
                                        last_name <-    contact.last_name,
                                        phone_number <- contact.phone_number,
                                        user_image <-   contact.user_image,
                                        user_email <-   contact.user_email))
            return true
        } catch let Result.error(message, code: code, statement) where code == SQLITE_CONSTRAINT{
            print("Insert roe failed: \(message), in \(statement)")
            return false
        } catch let error {
            print("Insertion failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // updating row
    static func update_row(_ contact_value: UserContact) -> Bool? {
        guard let db = SQLDB.share.data_base else {
            print("DB connection error")
            return nil
        }
        // get the appropiate contact from tableView accordint to its id
        let contact = set_table.filter(id == contact_value.id).limit(1)
        do {
            // update the contact's value
            if try db.run(contact.update(first_name <- contact_value.first_name,
                                         last_name <- contact_value.last_name,
                                         phone_number <- contact_value.phone_number,
                                         user_image <- contact_value.user_image,
                                         user_email <- contact_value.user_email)) > 0 {
                print("Updated contact")
                return true
            } else {
                print("Could not update the selected cntact")
                return false
            }
        } catch let Result.error(message, code: code, statement) where code == SQLITE_CONSTRAINT{
            print("Could not update row: \(message) in \(String(describing: statement))")
            return false
        } catch let error {
            print("The update failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // present row
    static func present_row() -> [UserContact]? {
        guard let db = SQLDB.share.data_base else {
            print("Data store connection error")
            return nil
        }
        // contact array
        var contact_array = [UserContact]()
        // sort contact data in decending order
        set_table = set_table.order(id.desc)
        do {
            for contact in try db.prepare(set_table) {
                let id_value =              contact[id]
                let first_name_value =      contact[first_name]
                let last_name_value =       contact[last_name]
                let phone_number_value =    contact[phone_number]
                let user_image_value =      contact[user_image]
                let user_email_value =      contact[user_email]
                
                // create object
                let contact_object = UserContact(id: id_value,
                                                 first_name: first_name_value,
                                                 last_name: last_name_value,
                                                 phone_number: phone_number_value,
                                                 user_image: user_image_value,
                                                 user_email: user_email_value)
                // add object to an array
                contact_array.append(contact_object)
                print("id: \(contact[id]), first_name: \(contact[first_name]), last_name: \(contact[last_name]), phone_number \(contact[phone_number]), user_image: \(contact[user_image]), user_email: \(contact[user_email])")
            }
        } catch {
            print("Rresent row error: \(error.localizedDescription)")
        }
        return contact_array
    }
}
