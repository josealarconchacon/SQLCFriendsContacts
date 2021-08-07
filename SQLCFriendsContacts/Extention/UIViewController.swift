//
//  UIViewController.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/7/21.
//

import UIKit

extension UIViewController {
    
    func error(_ title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
