//  ViewController.swift
//  Copyright © 2019 Nishant Arora. All rights reserved.

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var assignmentButton: UIButton!
    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nightModeLabel: UILabel!

    @IBOutlet weak var nightModeSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        assignmentButton.layer.cornerRadius = 10
        fitnessButton.layer.cornerRadius = 10
        calendarButton.layer.cornerRadius = 10
        sleepButton.layer.cornerRadius = 10
        
        let nightModeStatus = UserDefaults.standard.bool(forKey: "nightModeOn")
        
        if nightModeStatus {
            nightModeLabel.textColor = UIColor .white
            titleLabel.textColor = UIColor .white
            descriptionLabel.textColor = UIColor .white
            self.view.backgroundColor = UIColor .black
            self.view.setNeedsDisplay()
            nightModeSwitch.setOn(true, animated: true)
        } else {
            nightModeLabel.textColor = UIColor .black
            titleLabel.textColor = UIColor .black
            descriptionLabel.textColor = UIColor .black
            self.view.backgroundColor = UIColor(red: 90/255, green: 210/255, blue: 255/255, alpha: 1)
            self.view.setNeedsDisplay()
        }
        super.viewDidLoad()
    }
    
    @IBAction func toggleNightModeSwitch(_ sender: Any) {
        if nightModeSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "nightModeOn")
            nightModeLabel.textColor = UIColor .white
            titleLabel.textColor = UIColor .white
            descriptionLabel.textColor = UIColor .white
            self.view.backgroundColor = UIColor .black
            self.view.setNeedsDisplay()
        } else {
            UserDefaults.standard.set(false, forKey: "nightModeOn")
            nightModeLabel.textColor = UIColor .black
            titleLabel.textColor = UIColor .black
            descriptionLabel.textColor = UIColor .black
            self.view.backgroundColor = UIColor(red: 90/255, green: 210/255, blue: 255/255, alpha: 1)
            self.view.setNeedsDisplay()
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loadAssignmentView(_ sender: Any) {
        performSegue(withIdentifier: "toAssignmentView", sender: self)
    }
}

