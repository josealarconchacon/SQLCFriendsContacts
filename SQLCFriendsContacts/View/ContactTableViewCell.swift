//
//  ContactTableViewCell.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/11/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Set up contact values
    func contact_values(_ contact: UserContact) {
        contactName.text = contact.first_name + " " + contact.last_name
        contactPhone.text = contact.phone_number
        
        let image = UIImage(data: contact.user_image)
        contactImage.image = image
        contactImage.round_image()
    }

}
