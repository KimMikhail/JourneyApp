//
//  DetailsPresenter.swift
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

protocol DetailsPresentationLogic {
    func presentImage(response: Details.SetImage.Response)
    func presentStats(response: Details.SetStatistic.Response)
    func presentData(response: Details.ShowPhotos.Response)
    func presentMap(response: Details.SetMap.Response)
    func presentCenterMap(response: Details.CenterMap.Response)
}

class DetailsPresenter: DetailsPresentationLogic {
    
    weak var viewController: DetailsDisplayLogic?
    
    // MARK: Do something
    func presentStats(response: Details.SetStatistic.Response) {
        let viewModel = Details.SetStatistic.ViewModel(route: response.route)
        viewController?.displayStatsAndName(viewModel: viewModel)
    }
    func presentImage(response: Details.SetImage.Response) {
        let viewModel = Details.SetImage.ViewModel(image: response.image)
        viewController?.displayImage(viewModel: viewModel)
    }
    func presentData(response: Details.ShowPhotos.Response) {
        let viewModel = Details.ShowPhotos.ViewModel(route: response.route, photos: response.photos)
        viewController?.displayData(viewModel: viewModel)
    }
    func presentMap(response: Details.SetMap.Response) {
        let viewModel = Details.SetMap.ViewModel(coordinates: response.coordinates)
        viewController?.displayMap(viewModel: viewModel)
    }
    func presentCenterMap(response: Details.CenterMap.Response) {
        let viewModel = Details.CenterMap.ViewModel(region: response.region)
        viewController?.displayCenterMap(viewModel: viewModel)
    }
    
}
