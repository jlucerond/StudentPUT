//
//  StudentsTableViewController.swift
//  StudentPut
//
//  Created by Joe Lucero on 8/2/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRefreshControl()
        lookForStudents()
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return StudentController.students.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = StudentController.students[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        cell.textLabel?.text = student.name
        return cell
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        StudentController.putStudentWith(name: name) { (success) in
            
            if !success { return }
            
            DispatchQueue.main.async {
                self.nameTextField.text = ""
                self.nameTextField.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
    
    func lookForStudents() {
        StudentController.fetchStudents {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setUpRefreshControl() {
        let rc = UIRefreshControl()
        rc.addTarget(self,
                     action: #selector(self.refresh(refreshControl:)),
                     for: UIControlEvents.valueChanged)
        tableView.refreshControl = rc
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        lookForStudents()
        refreshControl.endRefreshing()
    }

}
