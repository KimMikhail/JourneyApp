//
//  DetailsRouter.swift
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

@objc protocol DetailsRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DetailsDataPassing {
    var dataStore: DetailsDataStore? { get }
}

class DetailsRouter: NSObject, DetailsRoutingLogic, DetailsDataPassing {
    
    weak var viewController: DetailsViewController?
    var dataStore: DetailsDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: DetailsViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: DetailsDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}
