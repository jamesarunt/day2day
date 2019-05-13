//  FitnessViewController.swift
//  Copyright © 2019 Arun James. All rights reserved.

import UIKit
import WebKit

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
        
        setButtonColor()
        
        super.viewDidLoad()
        
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

