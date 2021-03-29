//
//  Route.swift
//  Journey
//
//  Created by  Mikhail on 19.02.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import MapKit

class Route: Object {
    
    var coordinates = List<LocationCoordinate>()
    var speeds = List<Double>()
    var timeStamps = List<Date>()
    @objc dynamic var averageSpeed: Double
    @objc dynamic var distance: Double
    @objc dynamic var calories: Double
    @objc dynamic var steps: Int
    @objc dynamic var imageData: Data?
    
    init(coordinates: [LocationCoordinate], speeds: [Double], timeStamps: [Date], averageSpeed: Double, distance: Double, calories: Double, steps: Int) {
        self.coordinates.append(objectsIn: coordinates)
        self.speeds.append(objectsIn: speeds)
        self.timeStamps.append(objectsIn: timeStamps)
        self.averageSpeed = averageSpeed
        self.distance = distance
        self.calories = calories
        self.steps = steps
        
    }
    override required init() {
        
        self.averageSpeed = 0
        self.distance = 0
        self.calories = 0
        self.steps = 0
    }
    
}

class LocationCoordinate: Object{
    var lat: Double = 0
    var lon: Double = 0
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    override required init() {
        self.lat = 0
        self.lon = 0
    }
}
