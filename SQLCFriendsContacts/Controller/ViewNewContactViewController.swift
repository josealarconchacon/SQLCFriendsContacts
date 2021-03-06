//
//  ViewNewContactViewController.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/6/21.
//

import UIKit

class ViewNewContactViewController: UIViewController, UINavigationControllerDelegate {


    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    var model: ViewNewContactModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(add_image))
        userImageView.addGestureRecognizer(tap)
        userImageView.isUserInteractionEnabled = true
        
        createTable()
        set_up_views()
        userImageView.round_image()
        userFirstName.becomeFirstResponder()
        userPhoneNumber.delegate = self
    }

    /// connect to DB  and create table
    private func createTable() {
        let db = SQLDB.share
        db.create_db_table()
    }
    
    // set up view with the values of the contacts
    private func set_up_views() {
        if let view_model = model {
            userFirstName.text = view_model.first_name
            userLastName.text = view_model.last_name
            userPhoneNumber.text = view_model.phone_number
            userImageView.image = view_model.user_image
            userEmail.text = view_model.user_email
        }
    }
    // save new contact or an updated contact
    @IBAction func saveButtonPressed(_ sender: Any) {
        let id: Int = model == nil ? 0 : model.id!
        let first_name = userFirstName.text ?? ""
        let last_name = userLastName.text ?? ""
        let phone = userPhoneNumber.text ?? ""
        let email = userEmail.text ?? ""
        let image = userImageView.image
        
        guard let photo = image?.pngData() else { return }
        
        let contacts = UserContact(id: id,
                                   first_name: first_name,
                                   last_name: last_name,
                                   phone_number: phone ,
                                   user_image: photo,
                                   user_email: email)
        if model == nil {
            // contact created
            create_new_contact(contacts)
        } else {
            // contact was updated
            update_contact(contacts)
        }
        
        SQLiteCommand.present_row()
    }
    
    // create new contact
    private func create_new_contact(_ value: UserContact) {
        let add_contact_to_table = SQLiteCommand.insert_row(value)
        if add_contact_to_table == true {
            dismiss(animated: true, completion: nil)
        } else {
            display_error("Error: ", message: "Failed creating contact because it alrady exists")
        }
    }
    
    // update contact
    private func update_contact(_ contact_value: UserContact) {
        let contact_update_in_table = SQLiteCommand.update_row(contact_value)
        // since phone is unique for each contact, check if it already exists
        if contact_update_in_table == true {
            if let cell_tap = navigationController {
                cell_tap.popViewController(animated: true)
            }
        } else {
            display_error("Error", message: "Faild updating this contact because the phone number already exists")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let add_button = presentingViewController is UINavigationController
        if add_button {
            dismiss(animated: true, completion: nil)
        } else if let cell_clicked = navigationController {
            cell_clicked.popViewController(animated: true)
        } else {
            print("ContactTablevViewController is not inside a navegation controller")
        }
    }
}

extension ViewNewContactViewController: UIImagePickerControllerDelegate {
    @objc func add_image() {
        let image_picker = UIImagePickerController()
        image_picker.sourceType = .photoLibrary
        image_picker.delegate = self
        present(image_picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let select_image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Failed: \(info)")
        }
        userImageView.image = select_image
        dismiss(animated: true, completion: nil)
    }
}


extension ViewNewContactViewController: UITextFieldDelegate {
    // phone number validation
    private func format(with mask: String, phone: String) -> String {
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var final_result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" || character == "x" {
                final_result.append(number[index])
                index = number.index(after: index)
            } else {
                final_result.append(character)
            }
        }
        return final_result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text  else {
            return false
        }
        let new_text_string = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "(XXX) XXX-XXXX", phone: new_text_string)
        return false
    }
}
