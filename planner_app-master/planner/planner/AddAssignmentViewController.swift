//  AddAssignmentViewController.swift
//  Copyright © 2019 Nishant Arora. All rights reserved.

import UIKit

class AddAssignmentViewController: UIViewController {
    var assignmentVC = AssignmentViewController()
    var nightModeStatus = UserDefaults.standard.bool(forKey: "nightModeOn")

    @IBOutlet weak var assignmentNameField: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var createAssignmentButton: UIButton!
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        createAssignmentButton.layer.cornerRadius = 10
        
        if nightModeStatus {
            assignmentLabel.textColor = UIColor .white
            importantLabel.textColor = UIColor .white
            self.view.backgroundColor = UIColor .black
            
        } else {
            assignmentLabel.textColor = UIColor .black
            importantLabel.textColor = UIColor .black
            self.view.backgroundColor = UIColor(red: 90/255, green: 210/255, blue: 255/255, alpha: 1)
        }
        super.viewDidLoad()
    }
    
    @IBAction func addButtonWasTapped(_ sender: Any) {
        addAssignment()
    }
    
    func addAssignment() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let assignment = AssignmentCoreData.init(entity: AssignmentCoreData.entity(), insertInto: context)
            
            if assignmentNameField.text == "" {
                let alert = UIAlertController(title: "Invalid Name", message: "The name field cannot be left blank.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if let name = assignmentNameField.text {
                assignment.name = name
                assignment.important = importantSwitch.isOn
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy h:mm a"
                assignment.dueDate = dateFormatter.string(from: datePicker.date)
            }
            
            try? context.save()
            navigationController?.popViewController(animated: true)
        }
    }
}
