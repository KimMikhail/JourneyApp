//
//  DetailsViewController.swift
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

protocol DetailsDisplayLogic: class {
    func displayStatsAndName(viewModel: Details.SetStatistic.ViewModel)
    func displayData(viewModel: Details.ShowPhotos.ViewModel)
    func displayMap(viewModel: Details.SetMap.ViewModel)
    func displayCenterMap(viewModel: Details.CenterMap.ViewModel)
}

class DetailsViewController: UIViewController, DetailsDisplayLogic, MKMapViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var route: Route?
    var routeImage: UIImage?
    var photos = [UIImage]()
    var statsCell: StatisticCollectionViewCell!
    var interactor: DetailsBusinessLogic?
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    var coordinates: [CLLocationCoordinate2D]?
    var mapView: MKMapView!
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setImage()
        setStats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillPhotos()
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(UINib(nibName: "StatisticCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatisticCell")
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(UINib(nibName: "MapCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 7, height: UIScreen.main.bounds.width / 3 - 7)
        collectionView.collectionViewLayout = layout
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
    
    // MARK: Do something
    func setStats() {
        let request = Details.SetStatistic.Request()
        interactor?.prepareStats(request: request)
    }
    func displayStatsAndName(viewModel: Details.SetStatistic.ViewModel) {
        route = viewModel.route
        collectionView.reloadSections(IndexSet(integer: 1))
        self.title = route?.routeName
    }
    func setImage() {
        let mapRequest = Details.SetMap.Request()
        interactor?.prepareMap(request: mapRequest)
    }
    func displayMap(viewModel: Details.SetMap.ViewModel) {
        coordinates = viewModel.coordinates
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    func fillPhotos() {
        let request = Details.ShowPhotos.Request()
        interactor?.preparePhotos(request: request)
    }
    
    func displayData(viewModel: Details.ShowPhotos.ViewModel) {
        guard let photos = viewModel.photos else { return }
        self.photos = photos
        collectionView.reloadSections(IndexSet(integer: 2))
    }
    func displayCenterMap(viewModel: Details.CenterMap.ViewModel) {
        mapView?.setRegion(viewModel.region, animated: false)
    }
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = DetailsInteractor()
        let presenter = DetailsPresenter()
        let router = DetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}


extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 2:
            return photos.count
        default:
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCollectionViewCell
            if self.coordinates != nil && self.coordinates!.count > 0 {
                let polyline = MKPolyline(coordinates: self.coordinates!, count: coordinates!.count)
                self.mapView = cell.mapView
                self.mapView.delegate = self
                self.mapView.addOverlay(polyline)
                self.mapView.setCenter(self.coordinates!.first!, animated: true)
                let request = Details.CenterMap.Request()
                interactor?.centerMap(request: request)
            }
            
            return cell
        case 1:
            statsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticCell", for: indexPath) as? StatisticCollectionViewCell
            guard let route = route else {
                return statsCell
            }
            statsCell.fillCell(route: route)
            return statsCell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            cell.imageView.image = photos[indexPath.row]
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width, height: 120)
        default:
            return CGSize(width: UIScreen.main.bounds.width / 3 - 1 , height: UIScreen.main.bounds.width / 3 - 1)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1.5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let photoVC = PreviewPhotoViewController(nibName: "PreviewPhotoViewController", bundle: nil)
            _ = photoVC.view
            guard let photosView = photoVC.photosView else { return }
            for photo in photos {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: photosView.frame.height))
                imageView.contentMode = .scaleAspectFit
                imageView.image = photo
                photosView.addView(with: imageView)
            }
            present(photoVC, animated: true)
            
        }
    }
    
}

extension DetailsViewController {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 10
        renderer.strokeColor = .blue
        renderer.alpha = 0.5
        return renderer
    }
}
