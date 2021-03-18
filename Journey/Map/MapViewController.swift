//
//  MapViewController.swift
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
import CoreAnimation
import CoreLocation

protocol MapDisplayLogic: class {
    func displayRequestForCurrentLocation(viewModel: Map.LocationServicesRequest.ViewModel)
    func displayGetCurrentLocation(viewModel: Map.GetCurrentLocation.ViewModel)
    func displayCenterMap(viewModel: Map.CenterMap.ViewModel)
    func displaySavingRoute(viewModel: Map.SavingRoute.ViewModel)
    func displayStopSavingRoute(viewModel: Map.StopSavingRoute.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
    
    var centerMapFirstTime = false
    var isOnTheWay = false
    var currentLocation: CLLocation?
    
    
    var statisticViewController: StatisticViewController?
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        locationServicesRequest()
        healthKitRequest()
    }
    
    override func viewDidLayoutSubviews() {
        setupStatisticView()
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: Location Services Request
    
    func locationServicesRequest() {
        let request = Map.LocationServicesRequest.Request()
        interactor?.locationServicesRequest(request: request)
    }
    
    func displayRequestForCurrentLocation(viewModel: Map.LocationServicesRequest.ViewModel){
        if viewModel.success {
            mapView.showsUserLocation = true
            getCurrentLocation()
        } else {
            showAlert(title: viewModel.errorTitle ?? "unknown error", message: viewModel.errorMessage ?? "")
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Get Current Location
    
    func getCurrentLocation() {
        mapView.delegate = self
    }
    
    func displayGetCurrentLocation(viewModel: Map.GetCurrentLocation.ViewModel) {
        if viewModel.success {
            centerMap()
        }
    }
    // MARK: Health Kit Request
    
    func healthKitRequest() {
        let request = Map.HealthKitRequest.Request()
        interactor?.healthKitRequest(request: request)
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    private func setupStatisticView() {
        statisticViewController = StatisticViewController(controller: self, superview: mapView, handleAreaHeight: 64, cardHeight: 250, heightInCollapsedState: 64)
    }
    // MARK: Center Map
    func centerMap() {
        print(#function)
        if !centerMapFirstTime, let currentLocation = currentLocation {
            mapView.userTrackingMode = .followWithHeading
            let request = Map.CenterMap.Request(coordinates: currentLocation)
            interactor?.centerMap(request: request)
            centerMapFirstTime = true
        }
        
    }
    
    
    func displayCenterMap(viewModel: Map.CenterMap.ViewModel) {
        
        mapView.setCenter(viewModel.coordinates, animated: true)
        mapView.userTrackingMode = .followWithHeading
        
    }
    
    // MARK: Display Saving Route
    
    func displaySavingRoute(viewModel: Map.SavingRoute.ViewModel) {
        
        let polyline = MKPolyline(coordinates: viewModel.coordinates, count: viewModel.coordinates.count)
        
        statisticViewController?.fill(viewModel: viewModel)
        
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(polyline)
    }
    
    
    
    // MARK: Stop Saving Route
    

    func displayStopSavingRoute(viewModel: Map.StopSavingRoute.ViewModel) {
        router?.routeToRouteList(segue: UIStoryboardSegue(identifier: "", source: self, destination: (tabBarController?.viewControllers![1])!))
        
    }
   
    func saveLocation() {
        guard let location = mapView.userLocation.location else { return }
        let request = Map.SavingRoute.Request(location: location)
        interactor?.savingRoute(request: request)
    }
    
    func saveRoute() {
        
    }
    
    
    // MARK: Action
    
    /*
    func saveLocation(sender: Any) {
        let button = sender as! UIButton
        
        if button.titleLabel?.text == "Start" && mapView.userLocation.location != nil{
            button.setTitle("Stop", for: .normal)
            mapView.userTrackingMode = .followWithHeading
            isOnTheWay = true
            
            let request = Map.SavingRoute.Request(location: mapView.userLocation.location!)
            interactor?.savingRoute(request: request)
            
        } else {
            button.setTitle("Start", for: .normal)
            isOnTheWay = false
            
            var image: UIImage?
            let regionRect = mapView.overlays.first?.boundingMapRect
            let mapSnapOptions = MKMapSnapshotter.Options()
            mapSnapOptions.region = MKCoordinateRegion(regionRect!)
            
            let snapShot = MKMapSnapshotter(options: mapSnapOptions)
            snapShot.start { (snapShot, error) in
                if error == nil {
                    image = snapShot?.image
                    let request = Map.StopSavingRoute.Request(image: image)
                    self.interactor?.stopSavingRoute(request: request)
                }
            }
            
            
            
        }
    }
    */
    
    func getCenterMap() {
        mapView.userTrackingMode = .followWithHeading
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if isOnTheWay {
            let request = Map.SavingRoute.Request(location: userLocation.location!)
            self.interactor?.savingRoute(request: request)
            
        }
        
        let request = Map.GetCurrentLocation.Request(success: true)
        interactor?.getCurrentLocation(request: request)
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        currentLocation = nil
        let request = Map.GetCurrentLocation.Request(success: false, error: error as NSError)
        interactor?.getCurrentLocation(request: request)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 10
        renderer.strokeColor = .blue
        renderer.alpha = 0.5
        
        return renderer
    }
    
}

