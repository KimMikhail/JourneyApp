//
//  DetailsModels.swift
//  Journey
//
//  Created by  Mikhail on 29.03.2021.
//  Copyright (c) 2021  Mikhail. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
import MapKit

enum Details {
    // MARK: Use cases
    
    enum SetStatistic {
        struct Request {
        }
        struct Response {
            var route: Route
        }
        struct ViewModel {
            var route: Route
        }
    }
    enum ShowPhotos {
        struct Request {
        }
        
        struct Response {
            var route: Route
            var photos: [UIImage]?
        }
        
        struct ViewModel {
            var route: Route
            var photos: [UIImage]?
        }
    }
    enum SetMap {
        struct Request {
        }
        struct Response {
            var coordinates: [CLLocationCoordinate2D]
        }
        struct ViewModel {
            var coordinates: [CLLocationCoordinate2D]
        }
    }
    enum CenterMap {
        struct Request {
        }
        struct Response {
            var region: MKCoordinateRegion
        }
        struct ViewModel {
            var region: MKCoordinateRegion
        }
    }
}
