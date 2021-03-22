//
//  MapInteractor.swift
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
import MapKit
import CoreMotion
import HealthKit

protocol MapBusinessLogic {
    func locationServicesRequest(request: Map.LocationServicesRequest.Request)
    func centerMap(request: Map.CenterMap.Request)
    func healthKitRequest(request: Map.HealthKitRequest.Request)
    func savingRoute(request: Map.SavingRoute.Request)
    func stopSavingRoute(request: Map.StopSavingRoute.Request)
}

protocol MapDataStore {
    var route: Route? { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore, CLLocationManagerDelegate {
//    var route: Route
    
    
    var presenter: MapPresentationLogic?
    var worker = MapWorker()
    
    var locationManager = CLLocationManager()
    var mapView: MKMapView!
    
    
    var onMyWay = false
    
    var route: Route?
    var startTimeStamp: Date?
    
    // MARK: Location Services Request
    
    func locationServicesRequest(request: Map.LocationServicesRequest.Request)
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        var response: Map.LocationServicesRequest.Response
        switch status {
        case .authorizedAlways:
            response = Map.LocationServicesRequest.Response(success: true)
        case .restricted, .denied, .notDetermined, .authorizedWhenInUse:
            response = Map.LocationServicesRequest.Response(success: false)
        default:
            return
        }
        presenter?.presentRequestForCurrentLocation(response: response)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if onMyWay {
                guard let location = locations.last else { return }
                appendLocationToRoute(location: location)
                
                if route?.coordinates.count == 1 {
                    self.startTimeStamp = Date()
                }
                guard let lastLocation = locations.last else { return }
                appendLocationToRoute(location: lastLocation)
                guard let route = route else { return }
                
                let response = Map.SavingRoute.Response(route: route)
                presenter?.presentSavingRoute(response: response)
            }
        }
    // MARK: Get Current Location
    // MARK: Center Map
    
    func centerMap(request: Map.CenterMap.Request) {
        let response = Map.CenterMap.Response(coordinates: request.coordinates)
        presenter?.centerMap(response: response)
    }
    
    // MARK: Health Kit Request
    
    func healthKitRequest(request: Map.HealthKitRequest.Request) {
        let allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ])
        worker.healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                print("error")
            }
        }
    }
    
    
    
    // MARK: Saving Route
    
    func savingRoute(request: Map.SavingRoute.Request) {
        if !onMyWay { onMyWay.toggle() }
        appendLocationToRoute(location: request.location)
        guard let route = route else { return }
        
        let response = Map.SavingRoute.Response(route: route)
        presenter?.presentSavingRoute(response: response)
    }
    
    private func appendLocationToRoute(location: CLLocation) {
        if route == nil {
            route = Route(coordinates: [LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)], speeds: [Double(round(location.speed * 3.6 * 10) / 10)], timeStamps: [location.timestamp], averageSpeed: 0, distance: 0, calories: 0, steps: 0)
        }
        else {
            route?.coordinates.append((LocationCoordinate(lat: location.coordinate.latitude, lon: location.coordinate.longitude)))
            route?.speeds.append(Double(round(location.speed * 3.6 * 10) / 10) > 0 ? Double(round(location.speed * 3.6 * 10) / 10) : 0)
            route?.timeStamps.append(Date())
            
            let speeds = route?.speeds
            route?.averageSpeed = worker.calculateAverageSpeed(speeds:  speeds!)
            let coordinates = route?.coordinates
            route?.distance = worker.calculateDistance(coordinates: coordinates!)
            if route!.timeStamps.count > 0 {
                worker.calculateSteps(fromDate: route!.timeStamps.first!) { (steps) in
                    self.route?.steps = steps
                }
            }
        }
    }
    
    // MARK: Stop Saving Route
    
    func stopSavingRoute(request: Map.StopSavingRoute.Request) {
        onMyWay = false
        if request.image != nil {
            let data = request.image?.pngData()
            route?.imageData = data
        }
        guard let route = route else { return }
        let response = Map.StopSavingRoute.Response(route: route)
        presenter?.presentStopSavingRoute(response: response)
        self.route = nil
    }
}


