//
//  ViewNewContactModel.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/7/21.
//

import UIKit

class ViewNewContactModel {
    
    private var contact_values: UserContact?
    
    let id: Int?
    let first_name: String?
    let last_name: String?
    let phone_number: String?
    let user_image: UIImage?
    let user_email: String?
    
    init(contact_values: UserContact?) {
        self.contact_values = contact_values
        
        self.id = contact_values?.id
        self.first_name = contact_values?.first_name
        self.last_name = contact_values?.last_name
        self.phone_number = contact_values?.phone_number
        self.user_image = UIImage(data: contact_values!.user_image)
        self.user_email = contact_values?.user_email
    }
    
}


