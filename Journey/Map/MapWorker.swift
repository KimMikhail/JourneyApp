//
//  MapWorker.swift
//  Journey
//
//  Created by  Mikhail on 06.02.2021.
//  Copyright (c) 2021  Mikhail. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
import HealthKit
import CoreMotion
import RealmSwift

class MapWorker {
    var healthStore = HKHealthStore()
    let pedometr = CMPedometer()
    let activityManager = CMMotionActivityManager()
    
    func calculateDistance(coordinates: List<LocationCoordinate>) -> Double {
        var totalDistance = 0.0
        for index in 0..<coordinates.count - 2 {
            let first = CLLocation(latitude: coordinates[index].lat, longitude: coordinates[index].lon)
            let second = CLLocation(latitude: coordinates[index + 1].lat, longitude: coordinates[index + 1].lon)
            let distance = second.distance(from: first)
            totalDistance += distance
        }
        return Double(round(totalDistance / 1000 * 10) / 10)
    }
    
    func calculateAverageSpeed(speeds: List<Double>) -> Double {
        if speeds.count == 0 { return 0}
        var speedSum = 0.0
        for speed in speeds {
            speedSum += speed
        }
        return Double(round(speedSum / Double(speeds.count) * 10) / 10) > 0 ? Double(round(speedSum / Double(speeds.count) * 10) / 10) : 0
    }
    func calculateSteps(fromDate date: Date, completion: @escaping (Int) -> ()) {
        
        if CMPedometer.isStepCountingAvailable() {
            
            self.pedometr.startUpdates(from: date) { (data: CMPedometerData?, error) -> Void in
                if error != nil {
                    return
                }
                guard let data = data  else { return }
                completion(data.numberOfSteps.intValue)
            }
        }
    }
}
