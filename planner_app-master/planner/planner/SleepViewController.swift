import UIKit
import HealthKit

class SleepViewController: UIViewController {
    let healthStore = HKHealthStore()
    var sleepTime = 0.0
    var key = 0
    
    @IBOutlet var displayTimeLabel: UILabel!
    @IBOutlet weak var summaryButton: UIButton!
    @IBOutlet weak var titleLabel: UIButton!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var viewDataButton: UIButton!
    
    var initialTime = TimeInterval()
    var timer: Timer = Timer()
    var stopTime: NSDate!
    var alarmTime: NSDate!
    var nightModeStatus = UserDefaults.standard.bool(forKey: "nightModeOn")

    override func viewDidLoad() {
        if nightModeStatus {
            self.view.backgroundColor = UIColor .black
            displayTimeLabel.textColor = UIColor .white
            summaryButton.backgroundColor = UIColor .darkGray
            titleLabel.setTitleColor(UIColor.white, for: .normal)
            summaryButton.setTitleColor(UIColor.white, for: .normal)
            descriptionLabel.textColor = UIColor .white
            viewDataButton.setTitleColor(UIColor.white, for: .normal)

        } else {
            self.view.backgroundColor = UIColor(red: 90/255, green: 210/255, blue: 255/255, alpha: 1)
            displayTimeLabel.textColor = UIColor .black
            summaryButton.backgroundColor = UIColor .white
            titleLabel.setTitleColor(UIColor.black, for: .normal)
            summaryButton.setTitleColor(UIColor.black, for: .normal)
            descriptionLabel.textColor = UIColor .black
            viewDataButton.setTitleColor(UIColor.black, for: .normal)

        }
            
            
        let read = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!])
        let share = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!])
        summaryButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        self.healthStore.requestAuthorization(toShare: share, read: read) { (success, error) -> Void in
            if !success {
                NSLog("Permission Denied")
            }
        }
        super.viewDidLoad()
    }
    
    @IBAction func start() {
        summaryButton.setTitle("", for: .normal)
        alarmTime = NSDate()
        
        if (!timer.isValid) {
            let updater: Selector = #selector(SleepViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: updater, userInfo: nil, repeats: true)
            initialTime = NSDate.timeIntervalSinceReferenceDate
        }
        key = 1
    }
    
    @IBAction func stop() {
        stopTime = NSDate()
        saveData()
        fetchData()
        timer.invalidate()
        key = 0
    }
    
    @objc func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        var timeSlept: TimeInterval = currentTime - initialTime
        
        let mins = UInt8(timeSlept / 60.0)
        timeSlept -= (TimeInterval(mins) * 60)
        
        let seconds = UInt8(timeSlept)
        timeSlept -= TimeInterval(seconds)
        
        let milliseconds = UInt8(timeSlept * 100)
        
        displayTimeLabel.text = "\(String(format: "%02d", mins)):\(String(format: "%02d", seconds)):\(String(format: "%02d", milliseconds))"
    }

    func saveData() {
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            if alarmTime != nil {
                let object = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: self.alarmTime as Date, end: self.stopTime as Date)
                
                if key == 1 {
                    sleepTime += self.stopTime.timeIntervalSince(self.alarmTime as Date)
                    let hours = Int(sleepTime) / 3600
                    let minutes = Int(sleepTime) / 60 % 60
                    let seconds = Int(sleepTime) % 60
                    let interval = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    //                print("interval: \(interval)" )
                    summaryButton.setTitle("You slept for a total of \(interval) last night.", for: .normal)
                    key = 0
                }
                
                healthStore.save(object, withCompletion: { (success, error) -> Void in
                    if error != nil {
                        print("Error Saving Data")
                        return
                    }
                    
                    if success {
                        print("Data Saved")
                    } else {
                        print("Unexpected Error")
                    }
                })
                
                let object2 = HKCategorySample(type:sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: self.alarmTime as Date, end: self.stopTime as Date)
                
                healthStore.save(object2, withCompletion: { (success, error) -> Void in
                    if error != nil {
                        print("Error Saving Data")
                        return
                    }
                })
            }
        }
    }
    
    func fetchData() {
        if let data = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: data, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) {
                (query, temp, error) -> Void in
                
                if error != nil {
                    print("Error Fetching Data")
                    return
                }
                
                if let result = temp {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            print("Time Slept: \(sample.startDate) \(sample.endDate) - Value: \(value)")
                        }
                    }
                }
            }
            healthStore.execute(query)
        }
    }
        
//        let time = sleepTime/30
//        let hours = Int(time) / 3600
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//        let interval = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
//        summaryButton.setTitle("You Slept for \(sleepTime)", for: .normal)
   
    
    @IBAction func viewData(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "x-apple-health://")!)
        }
    }
}

