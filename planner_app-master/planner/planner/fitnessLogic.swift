//  fitnessLogic.swift
//  Copyright © 2019 Arun James. All rights reserved.

import Foundation
import UIKit
import HealthKit

class fitnessTracker {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    var steps : Int
    var calorie : Int
    var water : Int
    var stands : Int
    var moves : Int
    var sleeps : Int
    var minds : Int
    var exercises : Int
    var workouts : Int
    var rings : Int
    
    var str_steps = ""
    var str_calorie = ""
    var str_water = ""
    var str_stands = ""
    var str_moves = ""
    var str_sleeps = ""
    var str_minds = ""
    var str_exercises = ""
    var str_workouts = ""
    var str_rings = ""

    let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    let waterCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
    let stand = HKObjectType.categoryType(forIdentifier: .appleStandHour)
    let mind = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
    let move = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    let exercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
    let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
    let calories = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
    let weight = HKObjectType.quantityType(forIdentifier: .bodyMass)
    
    init(){
         print("initializing")
        
         //setData()
         steps = 0
         calorie = 1
         water = 1
         stands = 1
         moves = 1
         sleeps = 1
         minds = 1
         exercises = 1
         workouts = 1
         rings = 1
        let dataTypesToRead: Set<HKObjectType> = [stepsCount!, waterCount!, HKWorkoutType.workoutType(), stand!, mind, HKActivitySummaryType.activitySummaryType(), move, exercise!, sleep!, calories!, weight!]
        
        let dataTypesToWrite: Set<HKSampleType> = []
        
        healthKitStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { (success, error) -> Void in
            print("SUCCESS")
        }
        self.updateData()
        //self.setData()
    }
    

    
    
    func updateData(){
        getStepData(forDate: Date()) { (temp, _) -> Void in
        }
        
        getBodyMassData(forDate: Date()) { (bodyMass, _) -> Void in
            
        }
        
        getStepData(forDate: Date()) { (temp, _) -> Void in
            
        }
        getWorkOutData(forDate: Date()) { (eligible, _) -> Void in
            
        }
        getWaterData(forDate: Date()) { (water, _) -> Void in
            
        }
        getStandHours(forDate: Date()) { (hours, _) -> Void in
            
        }
        getMindSessions(forDate: Date()) { (mins, _) -> Void in
            
        }
        getActiveEnergy(forDate: Date()) { (energy, _) -> Void in
            
        }
        getExerciseTime(forDate: Date()) { (time, _) -> Void in
            
        }
        getSleepAnalysis(forDate: Date()) { (time, _) -> Void in
           
        }
        getCaloriesData(forDate: Date()) { (calories, _) -> Void in
            
        }
        getActivityRings(forDate: Date()) { (temp, _) -> Void in
            
        }
        
        
    }
    
    func setData(){
        self.str_steps = "\(self.steps)"
        self.str_workouts = "\(self.workouts) > 5 mins"
        self.str_water = "\(self.water) fl oz"
        self.str_sleeps = "\(self.sleeps) Hours"
        self.str_minds = "\(self.minds)"
        self.str_stands = "\(self.stands) Hours"
        self.str_exercises = "\(self.exercises) Minutes"
        self.str_moves = "\(self.moves) Calories"
        self.str_rings = "\(self.rings) Rings Closed"
        self.str_calorie = "\(self.calorie) Consumed"
        
//        print(self.steps)
//        print(self.calorie)
//        print(self.water)
//        print(self.stands)
//        print(self.moves)
//        print(self.sleeps)
//        print(self.minds)
//        print(self.exercises)
//        print(self.workouts)
//        print(self.rings)
//        print("HELLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
    }
    
    func getStepData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var steps = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        steps = quantity.doubleValue(for: HKUnit.count())
                        self.steps = Int (round(quantity.doubleValue(for: HKUnit.count())))
                        //Arun
//                        print (Int (round(quantity.doubleValue(for: HKUnit.count()))))
//                        print("inside")
//                        print("\(self.steps) hi")
                    }
                }
            }
            
            completion(round(steps), error)
        }
        healthKitStore.execute(query)
    }
    func getActiveEnergy(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var calories = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        self.calorie = Int(round(calories))
                    }
                }
            }
            completion(round(calories), error)
        }
        healthKitStore.execute(query)
    }
    func getExerciseTime(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var exercise = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        exercise = quantity.doubleValue(for: HKUnit.minute())
                        self.exercises = Int(round(exercise))
                    }
                }
            }
            completion(round(exercise), error)
        }
        healthKitStore.execute(query)
    }
    
    func getWorkOutData(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in
            
            var eligible = 0
            if let myResults = results as? [HKWorkout] {
                for workout in myResults where workout.duration >= 600 {
                    eligible += 1
                    
                }
                self.workouts = eligible
            }
            completion(eligible, error)
        }
        healthKitStore.execute(sampleQuery)
    }
    
    func getBodyMassData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        var startComps = DateComponents()
        startComps.year = 2000
        startComps.month = 1
        startComps.day = 1
        let startDate = startComps.date
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: cal.startOfDay(for: date))
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let weight = HKObjectType.quantityType(forIdentifier: .bodyMass)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: weight!, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var bodyMass = 0.0
            if let result = results?.first as? HKQuantitySample {
                bodyMass = result.quantity.doubleValue(for: HKUnit.pound())
                self.moves = Int(round(bodyMass))
            }
            completion(bodyMass, error)
        }
        healthKitStore.execute(query)
    }
    func getWaterData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                //  Something went Wrong
                return
            }
            var water = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        water = quantity.doubleValue(for: HKUnit.fluidOunceUS())
                        self.water = Int(round(water))
                    }
                }
            }
            completion(floor(water), error)
        }
        healthKitStore.execute(query)
        
    }
    
    func getCaloriesData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                //  Something went Wrong
                return
            }
            var calories = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    
                    if let quantity = statistics.sumQuantity() {
                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        self.calorie = Int(round(calories))
                    }
                }
            }
            completion(calories, error)
        }
        healthKitStore.execute(query)
        
    }
    
    func getStandHours(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        var dateComponents = cal.dateComponents(
            [.year, .month, .day],
            from: date
        )
        dateComponents.calendar = cal
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (_, summaries, error) in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var standHours = 0.0
            if let myResults = summaries {
                
                if myResults.count > 0 {
                    standHours = myResults[0].appleStandHours.doubleValue(for: HKUnit.count())
                    self.stands = Int(round(standHours))
                }
            }
            completion(Int(standHours), error)
        }
        healthKitStore.execute(query)
    }
    
    func getMindSessions(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        
        let endDate = cal.date(byAdding: comps, to: startDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .mindfulSession)!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var mindSessions = 0
            if let myResults = results {
                
                mindSessions = myResults.count
                self.minds = mindSessions
            }
            completion(mindSessions, error)
        }
        healthKitStore.execute(sampleQuery)
    }
    
    func getSleepAnalysis(forDate date: Date, _ completion: ((Int, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date).addingTimeInterval(-3600 * 12)
        let endDate = cal.startOfDay(for: date).addingTimeInterval(3600 * 12)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let sampleQuery = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (_, results, error ) -> Void in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var minutes = 0
            if let myResults = results {
                for item in myResults {
                    if let sample = item as? HKCategorySample {
                        
                        if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                            minutes += Int(sample.endDate.timeIntervalSince(sample.startDate) / 60)
                            self.sleeps = minutes
                        }
                    }
                }
            }
            completion(minutes, error)
        }
        
        healthKitStore.execute(sampleQuery)
    }
    
    func getActivityRings(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        var dateComponents = cal.dateComponents(
            [.year, .month, .day],
            from: date
        )
        dateComponents.calendar = cal
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (_, summaries, error) in
            if error != nil {
                
                //  Something went Wrong
                return
            }
            var moveGoal = 0.0
            if let myResults = summaries {
                
                if myResults.count > 0 {
                    moveGoal = myResults[0].activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
                    self.rings = Int(round(moveGoal))
                }
            }
            completion(moveGoal, error)
        }
        healthKitStore.execute(query)
    }

    
    
    func loadHealthDay() {
        
//        getBodyMassData(forDate: Date()) { (bodyMass, _) -> Void in
//            HealthDay.shared.bodyMass = bodyMass
//        }
//        getStepData(forDate: Date()) { (temp, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .steps })?.value = Int(temp)
//        }
//        getWorkOutData(forDate: Date()) { (eligible, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .workouts })?.value = Int(eligible)
//        }
//        getWaterData(forDate: Date()) { (water, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .water })?.value = Int(water)
//        }
//        getStandHours(forDate: Date()) { (hours, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .stand })?.value = Int(hours)
//        }
//        getMindSessions(forDate: Date()) { (mins, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .mind })?.value = Int(mins)
//        }
//        getActiveEnergy(forDate: Date()) { (energy, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .move })?.value = Int(energy)
//        }
//        getExerciseTime(forDate: Date()) { (time, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .exercise })?.value = Int(time)
//        }
//        getSleepAnalysis(forDate: Date()) { (time, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .sleep })?.value = Int(time)
//        }
//        getCaloriesData(forDate: Date()) { (calories, _) -> Void in
//            HealthDay.shared.attributes.first(where: { $0.type == .calories })?.value = Int(calories)
//        }
//        getActivityRings(forDate: Date()) { (temp, _) -> Void in
//            HealthDay.shared.moveGoal = temp
//        }
    }
    
//    func valueChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!) {
//        loadHealthDay()
//        completionHandler()
//    }
//
//    func startObservingBodyMass() {
//        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of body mass changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of body mass changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingStandHours() {
//        let sampleType = HKObjectType.categoryType(forIdentifier: .appleStandHour)!
//
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
//
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Stand Hour changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Stand Hour changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingWaterChanges() {
//        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of water changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of water changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingCaloriesChanges() {
//        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Calories changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Calories changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingWorkoutChanges() {
//        let sampleType = HKObjectType.workoutType()
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of workout changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of workout changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingStepChanges() {
//
//        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
//
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Step changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Step changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingExerciseChanges() {
//
//        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueChangedHandler)
//
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Exercise changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Exercise changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingActiveCalories() {
//        let sampleType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
//
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
//
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Active Energy changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Active Energy changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingMindSessions() {
//        let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
//
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
//
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Mind Session changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Mind Session changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }
//
//    func startObservingSleep() {
//        let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//
//        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueChangedHandler)
//
//        healthKitStore.execute(query)
//        healthKitStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: { (succeeded: Bool, error: Error!) in
//
//            if succeeded {
//                print("Enabled background delivery of Sleep Analysis changes")
//            } else {
//                if let theError = error {
//                    print("Failed to enable background delivery of Sleep Analysis changes. ")
//                    print("Error = \(theError)")
//                }
//            }
//        })
//    }

   
//    func getData(){
//        let dataTypesToWrite: Set<HKSampleType> = []
//
//        let dataTypesToRead: Set<HKObjectType> = [stepsCount!, waterCount!, HKWorkoutType.workoutType(), stand!, mind, HKActivitySummaryType.activitySummaryType(), move, exercise!, sleep!, calories!, weight!]
//
//        healthStore?.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) { (success, error) -> Void in
//            if Collection != nil {
//
//                self.startObservingQueries()
//                completion(success, error)
//            }
//
//        healthStore?.requestAuthorization(toShare: dataTypesToWrite as? Set<HKSampleType>, read: dataTypesToRead as Set<HKObjectType>,completion: {
//            [unowned self] (success, error) in
//             if success {
//                print("SUCCESS")
//             } else {
//                print(error.debugDescription)
//            }
//        })
    
//    }
    
}
