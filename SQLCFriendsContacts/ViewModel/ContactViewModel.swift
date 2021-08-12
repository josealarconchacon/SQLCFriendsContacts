//
//  ContactViewModel.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/11/21.
//

import Foundation


class ContactViewModel {
    
    private var contact_array = [UserContact]()
    
    func connect_database() {
        let _ = SQLDB.share
    }
    
    func load_data_from_database() {
        contact_array = SQLiteCommand.present_row() ?? []
    }
    
    func number_of_row_in_section(section: Int) -> Int {
        if contact_array.count != 0 {
            return contact_array.count
        }
        return 0
    }
    
    func cell_for_row_at(indexPath: IndexPath) -> UserContact {
        return contact_array[indexPath.row]
    }
}
