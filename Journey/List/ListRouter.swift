//
//  ListRouter.swift
//  Journey
//
//  Created by  Mikhail on 01.03.2021.
//  Copyright (c) 2021  Mikhail. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ListRoutingLogic {
    func routeToDetails(segue: UIStoryboardSegue?, route: Route)
}

protocol ListDataPassing {
    var dataStore: ListDataStore? { get }
}

class ListRouter: NSObject, ListRoutingLogic, ListDataPassing {
    
    weak var viewController: ListViewController?
    var dataStore: ListDataStore?
    
    // MARK: Routing
    
    func routeToDetails(segue: UIStoryboardSegue?, route: Route) {
        
        guard let destinationVC = segue?.destination as? DetailsViewController else { return }
        guard var destinationDS = destinationVC.router?.dataStore else { return }
        passDataToDetails(source: dataStore!, destination: &destinationDS, route: route)
        navigateToDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetails(source: ListViewController, destination: DetailsViewController) {
        source.performSegue(withIdentifier: "DetailsSegue", sender: source)
    }
    
    // MARK: Passing data
    
    func passDataToDetails(source: ListDataStore, destination: inout DetailsDataStore, route: Route?) {
        guard let route = route else { return }
        destination.route = route
    }
}
