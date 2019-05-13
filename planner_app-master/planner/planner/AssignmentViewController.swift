//  AssignmentViewController.swift
//  Copyright © 2019 Nishant Arora. All rights reserved.

import UIKit

class AssignmentViewController: UITableViewController {
    var assignments: [AssignmentCoreData] = []
    var nightModeStatus = UserDefaults.standard.bool(forKey: "nightModeOn")
    
    override func viewDidLoad() {
        if nightModeStatus {
            self.tableView.backgroundColor = UIColor .black
        } else {
            self.tableView.backgroundColor = UIColor .white
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAssignments()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }

    func sortByDate() {
        assignments = assignments.sorted { $0.dateTime! < $1.dateTime! }
        self.tableView.reloadData()
    }
    
    func sortByName() {
        assignments = assignments.sorted { $0.name! < $1.name! }
        self.tableView.reloadData()
    }
    
    func sortByDateAdded() {
        assignments = assignments.sorted { $0.dateAdded! < $1.dateAdded! }
        self.tableView.reloadData()
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sort By:", message: "Select a category.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Name (A-Z)", style: UIAlertAction.Style.default, handler: { action in
            self.sortByName()
        }))
        alert.addAction(UIAlertAction(title: "Due Date", style: UIAlertAction.Style.default, handler:  { action in
            self.sortByDate()
        }))
        alert.addAction(UIAlertAction(title: "Date Added", style: UIAlertAction.Style.default, handler:  { action in
            self.sortByDateAdded()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let assignment = assignments[indexPath.row]
        
        if nightModeStatus {
            cell.backgroundColor = UIColor .black
            cell.textLabel?.textColor = UIColor .white
        } else {
            cell.backgroundColor = UIColor .white
            cell.textLabel?.textColor = UIColor .black
        }
        if let name = assignment.name {
            cell.textLabel?.text = name
            cell.textLabel?.font = UIFont(name: (cell.textLabel?.font?.fontName)!, size: 18)
            if assignment.important {
                cell.textLabel?.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
                // UIColor(red: 0.4, green: 0.82, blue: 0.4, alpha: 1.0)
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addAssignmentVC = segue.destination as? AddAssignmentViewController {
            addAssignmentVC.assignmentVC = self
        }
        
        if let removeAssignmentVC = segue.destination as? RemoveAssignmentViewController {
            if let assignment = sender as? AssignmentCoreData {
                removeAssignmentVC.selectedAssignment = assignment
                removeAssignmentVC.assignmentVC = self
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignment = assignments[indexPath.row]
        performSegue(withIdentifier: "goToRemove", sender: assignment)
    }
    
    func getAssignments() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataAssignments = try? context.fetch(AssignmentCoreData.fetchRequest()) as? [AssignmentCoreData] {
                if let assignmentsCoreData = coreDataAssignments {
                    assignments = assignmentsCoreData
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDelete = assignments[indexPath.row]
                assignments.remove(at: indexPath.row)
                context.delete(toDelete)
                try? context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
