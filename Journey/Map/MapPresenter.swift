//
//  MapPresenter.swift
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
import MapKit
import RealmSwift

protocol MapPresentationLogic {
    func presentRequestForCurrentLocation(response: Map.LocationServicesRequest.Response)
    func presentGetCurrentLocation(response: Map.GetCurrentLocation.Response)
    func centerMap(response: Map.CenterMap.Response)
    func presentSavingRoute(response: Map.SavingRoute.Response)
    func presentStopSavingRoute(response: Map.StopSavingRoute.Response)
}

class MapPresenter: MapPresentationLogic {
    
    weak var viewController: MapDisplayLogic?
    
    
    // MARK: Current Location Request
    
    func presentRequestForCurrentLocation(response: Map.LocationServicesRequest.Response) {
        var viewModel: Map.LocationServicesRequest.ViewModel
        if response.success {
            viewModel = Map.LocationServicesRequest.ViewModel(success: true,
                                                              errorTitle: nil,
                                                              errorMessage: nil)
        } else {
            viewModel = Map.LocationServicesRequest.ViewModel(success: false,
                                                              errorTitle: "Location Disabled",
                                                              errorMessage: "Please enable location services in the Settings app.")
        }
        viewController?.displayRequestForCurrentLocation(viewModel: viewModel)
    }
    
    // MARK: Get Current Location
    
    func presentGetCurrentLocation(response: Map.GetCurrentLocation.Response) {
        
        var viewModel: Map.GetCurrentLocation.ViewModel
        if response.success {
            viewModel = Map.GetCurrentLocation.ViewModel(success: true,
                                                         errorTitle: nil,
                                                         errorMessage: nil)
        } else {
            let errorTitle = "Error"
            let errorMessage: String?
            if response.error?.code == CLError.locationUnknown.rawValue {
                errorMessage = "Your location could not be determined."
            } else {
                errorMessage = response.error?.localizedDescription
            }
            viewModel = Map.GetCurrentLocation.ViewModel(success: false,
                                                         errorTitle: errorTitle,
                                                         errorMessage: errorMessage)
        }
        viewController?.displayGetCurrentLocation(viewModel: viewModel)
    }
    
    // MARK: Center Map
    
    func centerMap(response: Map.CenterMap.Response) {
        let viewModel = Map.CenterMap.ViewModel(coordinates: response.coordinates.coordinate)
        viewController?.displayCenterMap(viewModel: viewModel)
    }
    
    // MARK: Saving Route
    func presentSavingRoute(response: Map.SavingRoute.Response) {
        let timeInterval = response.route.timeStamps.count > 1 ?  response.route.timeStamps.last!.timeIntervalSince(response.route.timeStamps.first!) : 0
        let timeString = getTimeString(timeInterval: timeInterval)
        
        let viewModel = Map.SavingRoute.ViewModel(coordinates: getCoordinates(coordinates: response.route.coordinates), currentSpeed: response.route.speeds.last!, timeString: timeString, distance: response.route.distance, avgSpeed: response.route.averageSpeed, steps: response.route.steps)
        viewController?.displaySavingRoute(viewModel: viewModel)
    }
    
    private func getTimeString(timeInterval: TimeInterval) -> String {
        let ti = Int(timeInterval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds) as String
    }
    private func getCoordinates(coordinates: List<LocationCoordinate>) -> [CLLocationCoordinate2D]{
        var coords = [CLLocationCoordinate2D]()
        for coordinate in coordinates {
            coords.append(CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon))
        }
        return coords
    }
    
    
    // MARK: Stop Saving Route
    
    func presentStopSavingRoute(response: Map.StopSavingRoute.Response) {
        let viewModel = Map.StopSavingRoute.ViewModel(route: response.route)
        viewController?.displayStopSavingRoute(viewModel: viewModel)
    }
}
