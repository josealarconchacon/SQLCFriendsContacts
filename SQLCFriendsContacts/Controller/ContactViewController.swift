//
//  ContactViewController.swift
//  SQLCFriendsContacts
//
//  Created by Jose Alarcon Chacon on 8/11/21.
//

import UIKit

class ContactViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var display_contact_viewModel = ContactViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // connect to DB
        display_contact_viewModel.connect_database()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        load_data()
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
    }
    
    // lead data from SQLite DB
    private func load_data() {
        display_contact_viewModel.load_data_from_database()
    }
    
    // select contact from tableViewCell to ViewNewContactViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            guard let new_contact_vc = segue.destination as? ViewNewContactViewController else {
                return
            }
            guard let selected_contact_cell = sender as? ContactTableViewCell else {
                return
            }
            if let index_path = tableView.indexPath(for: selected_contact_cell) {
                let selected_contact = display_contact_viewModel.cell_for_row_at(indexPath: index_path)
                new_contact_vc.model = ViewNewContactModel(contact_values: selected_contact)
            }
        }
    }
}

extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        display_contact_viewModel.number_of_row_in_section(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data_object = display_contact_viewModel.cell_for_row_at(indexPath: indexPath)
        if let contact_cell = cell as? ContactTableViewCell {
            contact_cell.contact_values(data_object)
        }
        return cell
    }
}

extension ContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        display_contact_viewModel.height_for_row_at(indexPath: indexPath)
    }
}
