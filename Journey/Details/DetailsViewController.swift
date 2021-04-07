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
protocol DetailsDisplayLogic: class {
    func displayImage(viewModel: Details.SetImage.ViewModel)
    func displayStatsAndName(viewModel: Details.SetStatistic.ViewModel)
    func displayData(viewModel: Details.ShowPhotos.ViewModel)
}

class DetailsViewController: UIViewController, DetailsDisplayLogic {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var route: Route?
    var routeImage: UIImage?
    var photos = [UIImage]()
    var statsCell: StatisticCollectionViewCell!
    var interactor: DetailsBusinessLogic?
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    
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
        let request = Details.SetImage.Request()
        interactor?.prepareImage(request: request)
    }
    func displayImage(viewModel: Details.SetImage.ViewModel) {
        routeImage = viewModel.image
        collectionView.reloadData()
    }
    func fillPhotos() {
        let request = Details.ShowPhotos.Request()
        interactor?.preparePhotos(request: request)
    }
    
    func displayData(viewModel: Details.ShowPhotos.ViewModel) {
        guard let photos = viewModel.photos else { return }
        self.photos = photos
        collectionView.reloadData()
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            if routeImage != nil {
                cell.imageView.image = routeImage!
            } else {
                cell.imageView.contentMode = .scaleAspectFill
                cell.imageView.image = UIImage(named: "LaunchScreen")
                
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
}
