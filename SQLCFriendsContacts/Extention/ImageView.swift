//
//  ImageView.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/7/21.
//

import UIKit

extension UIImageView {
    func round_image() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
