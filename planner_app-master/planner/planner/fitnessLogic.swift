//
//  fitnessLogic.swift
//  fitnessTracker
//
//  Created by Arun James on 5/11/19.
//  Copyright © 2019 Arun James. All rights reserved.
//

import Foundation
import UIKit

enum fitnessTracker: String{
    case steps = "Steps"
    case water = "Water"
    case stand = "Stand Hours"
    case sleep = "Sleep"
    case workouts = "Workouts"
    case mind = "Mind Sessions"
    case move = "Move"
    case exercise = "Exercise"
    case rings = "Watch Rings"
    case calories = "Calories"
    
    func getBackgroundColor() -> UIColor {
        switch self {
        case .steps:
            return UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        case .stand:
            return UIColor(red:0.38, green:0.87, blue:0.84, alpha:1.00)
        case .workouts:
            return UIColor(red:0.91, green:0.36, blue:0.28, alpha:1.00)
        case .water:
            return UIColor(red:0.38, green:0.75, blue:0.98, alpha:1.00)
        case .mind:
            return UIColor(red:0.33, green:0.73, blue:0.82, alpha:1.00)
        case .exercise:
            return UIColor(red:0.66, green:0.95, blue:0.29, alpha:1.00)
        case .move:
            return UIColor(red:0.89, green:0.24, blue:0.37, alpha:1.00)
        case .sleep:
            return UIColor(red:0.49, green:0.36, blue:0.92, alpha:1.00)
        case  .calories:
            return UIColor(red:0.32, green:0.71, blue:0.30, alpha:1.00)
        case .rings:
            return UIColor.lightGray
            
        }
    }
}
