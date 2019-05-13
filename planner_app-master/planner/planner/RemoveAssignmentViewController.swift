//  RemoveAssignmentViewController.swift
//  Copyright © 2019 Nishant Arora. All rights reserved.

import UIKit

class RemoveAssignmentViewController: UIViewController {
    var assignmentVC = AssignmentViewController()
    var selectedAssignment: AssignmentCoreData?
    var nightModeStatus = UserDefaults.standard.bool(forKey: "nightModeOn")

    @IBOutlet weak var dueDateHeader: UILabel!
    @IBOutlet weak var assignmentHeader: UILabel!
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var assignmentDueDateLabel: UILabel!
    @IBOutlet weak var removeAssignmentButton: UIButton!
    
    override func viewDidLoad() {
        removeAssignmentButton.layer.cornerRadius = 10
        
        if nightModeStatus {
            assignmentName.textColor = UIColor .white
            assignmentDueDateLabel.textColor = UIColor .white
            assignmentHeader.textColor = UIColor .white
            dueDateHeader.textColor = UIColor .white
            self.view.backgroundColor = UIColor .black
            
        } else {
            assignmentName.textColor = UIColor .black
            assignmentDueDateLabel.textColor = UIColor .black
            assignmentHeader.textColor = UIColor .black
            dueDateHeader.textColor = UIColor .black
            self.view.backgroundColor = UIColor(red: 90/255, green: 210/255, blue: 255/255, alpha: 1)
        }
        
        assignmentName.text = selectedAssignment?.name
        assignmentDueDateLabel.text = selectedAssignment?.dueDate!
        super.viewDidLoad()
    }
   
    
    @IBAction func removeAssignmentButtonTapped(_ sender: Any) {
        removeAssignment()
    }
    
    func removeAssignment() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let toDelete = selectedAssignment {
                context.delete(toDelete)
                try? context.save()
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
