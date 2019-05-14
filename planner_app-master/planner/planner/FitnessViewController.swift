//  FitnessViewController.swift
//  Copyright © 2019 Arun James. All rights reserved.

import UIKit
import WebKit
import HealthKit

class FitnessViewController: UIViewController {

    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var Step: UIButton!
    @IBOutlet weak var Sleep: UIButton!
    @IBOutlet weak var Workouts: UIButton!
    @IBOutlet weak var Stand: UIButton!
    @IBOutlet weak var Move: UIButton!
    @IBOutlet weak var Mind: UIButton!
    @IBOutlet weak var Calorie: UIButton!
    @IBOutlet weak var Exercise: UIButton!
    @IBOutlet weak var Water: UIButton!
    @IBOutlet weak var Ring: UIButton!
    
    //Labels
    @IBOutlet weak var Step_label: UILabel!
    @IBOutlet weak var Sleep_label: UILabel!
    @IBOutlet weak var Workouts_label: UILabel!
    @IBOutlet weak var Stand_label: UILabel!
    @IBOutlet weak var Move_label: UILabel!
    @IBOutlet weak var Mind_label: UILabel!
    @IBOutlet weak var Calorie_label: UILabel!
    @IBOutlet weak var Exercise_label: UILabel!
    @IBOutlet weak var Water_label: UILabel!
    @IBOutlet weak var Watch_label: UILabel!
    @IBOutlet weak var fitness_title: UILabel!
    @IBOutlet weak var workouts_title: UILabel!
    
    //ImageViews
    @IBOutlet weak var Steps_img: UIImageView!
    @IBOutlet weak var Workouts_img: UIImageView!
    @IBOutlet weak var Sleep_img: UIImageView!
    @IBOutlet weak var Stand_img: UIImageView!
    @IBOutlet weak var Move_img: UIImageView!
    @IBOutlet weak var Mind_img: UIImageView!
    @IBOutlet weak var Calorie_img: UIImageView!
    @IBOutlet weak var Exercise_img: UIImageView!
    @IBOutlet weak var Water_img: UIImageView!
    @IBOutlet weak var Watch_img: UIImageView!
    
    
    
    
    
    
    
    @IBOutlet var WorkoutButtons: [UIButton]!
    
    var healthData = fitnessTracker()
    
    var nightModeStatus = UserDefaults.standard.bool(forKey: "nightModeOn")

    // Define the UIButton
    
    let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
    let image = UIImage(named: "name") as UIImage?
    
    override func viewDidLoad() {
        
        if nightModeStatus {
            self.view.backgroundColor = UIColor .black
        } else {
            self.view.backgroundColor = UIColor .white
        }
        for button in self.allButtons {
            button.layer.cornerRadius = 10.0
        }
        
        for button in self.WorkoutButtons {
            button.layer.cornerRadius = 10.0
        }
        
        fitness_title.layer.masksToBounds = true
        workouts_title.layer.masksToBounds = true
        fitness_title.layer.cornerRadius = 10.0
        workouts_title.layer.cornerRadius = 10.0
        
        setButtonColor()
        healthData.setData()
        super.viewDidLoad()
        setLabels()
        setImg()

        
        //pdf close button
    }
    
    func setButtonColor(){
        Step.backgroundColor = UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        Sleep.backgroundColor = UIColor(red:0.49, green:0.36, blue:0.92, alpha:1.00)
        Workouts.backgroundColor = UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        Stand.backgroundColor = UIColor(red:0.38, green:0.87, blue:0.84, alpha:1.00)
        Move.backgroundColor = UIColor(red:0.89, green:0.24, blue:0.37, alpha:1.00)
        Mind.backgroundColor = UIColor(red:0.33, green:0.73, blue:0.82, alpha:1.00)
        Calorie.backgroundColor = UIColor(red:0.32, green:0.71, blue:0.30, alpha:1.00)
        Exercise.backgroundColor = UIColor(red:0.66, green:0.95, blue:0.29, alpha:1.00)
        Water.backgroundColor = UIColor(red:0.38, green:0.75, blue:0.98, alpha:1.00)
        Ring.backgroundColor = UIColor(red: 0.8275, green: 0.8275, blue: 0.8118, alpha: 1.0)
    }
    
    func setLabels(){
        Step_label.text = healthData.str_steps
        Sleep_label.text = healthData.str_sleeps
        Workouts_label.text = healthData.str_workouts
        Stand_label.text = healthData.str_stands
        Move_label.text = healthData.str_moves
        Mind_label.text = healthData.str_minds
        Calorie_label.text = healthData.str_calorie
        Exercise_label.text = healthData.str_exercises
        Water_label.text = healthData.str_water
        Watch_label.text = healthData.str_rings
    }
    
    func setImg(){
        let sadImage: UIImage = UIImage(named: "sad")!
        let happyImage: UIImage = UIImage(named: "happy")!
        if healthData.steps < 3000 {
            Steps_img.image = sadImage
        } else {
             Steps_img.image = happyImage
        }
        
        if healthData.sleeps < 8 {
            Sleep_img.image = sadImage
        } else {
            Sleep_img.image = happyImage
        }
        
        if healthData.workouts < 1 {
            Workouts_img.image = sadImage
        } else {
            Workouts_img.image = happyImage
        }
        
        if healthData.stands < 4 {
            Stand_img.image = sadImage
        } else {
            Stand_img.image = happyImage
        }
        
        if healthData.moves < 300 {
            Move_img.image = sadImage
        } else {
            Move_img.image = happyImage
        }
        
        if healthData.minds < 2 {
            Mind_img.image = sadImage
        } else {
            Mind_img.image = happyImage
        }
        
        if healthData.calorie < 500 {
            Calorie_img.image = sadImage
        } else {
            Calorie_img.image = happyImage
        }
        
        if healthData.exercises < 3 {
            Exercise_img.image = sadImage
        } else {
            Exercise_img.image = happyImage
        }
        
        if healthData.water < 60 {
            Water_img.image = sadImage
        } else {
            Water_img.image = happyImage
        }
        
        if healthData.rings < 3000 {
            Watch_img.image = sadImage
        } else {
            Watch_img.image = happyImage
        }
    }
    
    @IBAction func MonWorkout(_ sender: Any) {
        let url = Bundle.main.url(forResource: "mon", withExtension: "pdf")
        
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        }    }
    
    @IBAction func TueWorkout(_ sender: Any) {
        let url = Bundle.main.url(forResource: "tue", withExtension: "pdf")
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        }
    }
    
    @IBAction func WedWorkout(_ sender: Any) {
        let url = Bundle.main.url(forResource: "wed", withExtension: "pdf")
        
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        }
    }
    
    @IBAction func ThurWorkout(_ sender: Any) {
        let url = Bundle.main.url(forResource: "thur", withExtension: "pdf")
        
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        }
    }
    
    @IBAction func FriWorkout(_ sender: Any) {
        let url = Bundle.main.url(forResource: "fri", withExtension: "pdf")
        
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        }
    }
    
    @IBAction func SatWorkout(_ sender: Any) {
        let url = Bundle.main.url(forResource: "sat", withExtension: "pdf")
        
        if let url = url {
            let webView = WKWebView(frame: view.frame)
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            view.addSubview(webView)
        }
    }
    
}

