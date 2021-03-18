//
//  StatisticViewController.swift
//  Journey
//
//  Created by  Mikhail on 15.03.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import UIKit

class StatisticViewController: CardViewController {

    var startRouteButton: UIButton!
    var centerButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendButtonsToHandleArea()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func appendButtonsToHandleArea() {
        let startButtonFrame = CGRect(x: handleArea.bounds.width / 2 - 60, y: 12, width: 120, height: 30)
        let centerButtonFrame = CGRect(x: handleArea.bounds.width - 12 - 30, y: 12, width: 30, height: 30)
        startRouteButton = UIButton(frame: startButtonFrame)
        handleArea.addSubview(startRouteButton)
        startRouteButton.tintColor = .white
        startRouteButton.layer.cornerRadius = 12
        startRouteButton.clipsToBounds = true
        startRouteButton.setTitle("Start", for: .normal)
        startRouteButton.setTitleColor(UIColor(white: 1, alpha: 0.4), for: .highlighted)
        startRouteButton.layer.borderWidth = 1
        startRouteButton.layer.borderColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        startRouteButton.addTarget(self, action: #selector(startRouteAction(_:)), for: .touchUpInside)
        
        centerButton = UIButton(frame: centerButtonFrame)
        handleArea.addSubview(centerButton)
        centerButton.setImage(UIImage(named: "arrow"), for: .normal)
        centerButton.addTarget(self, action: #selector(centerAction(_:)), for: .touchUpInside)
    }
    
    func fill(viewModel: Map.SavingRoute.ViewModel) {
        self.timeLabel.text = viewModel.timeString
        self.distanceLabel.text = "\(viewModel.distance)"
        self.speedLabel.text = "\(viewModel.currentSpeed)"
        self.averageSpeedLabel.text = "\(viewModel.avgSpeed)"
        self.stepsLabel.text = "\(viewModel.steps)"
    }
    @objc func startRouteAction(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let mapVC = controller as? MapViewController else { return }
        guard let _ = mapVC.mapView.userLocation.location else { return }
        mapVC.saveLocation()
        mapVC.isOnTheWay = true
        UIView.animate(withDuration: 0.5) { [self] in
            let frame = CGRect(x: 6, y: 12, width: (button.superview?.frame.width)! - 12 - self.centerButton.frame.width - ((button.superview?.frame.maxX)! - self.centerButton.frame.maxX), height: 30)
            let panGesture = UIPanGestureRecognizer(target: mapVC, action: #selector(swipeToStopGesture(recognizer: )))
            
//            button.transform = CGAffineTransform(translationX: -(self.handleArea.frame.width / 2) + button.frame.width / 2 + 6, y: 0)
//            button.layer.cornerRadius = 0
            button.frame = frame
            button.setTitle("||", for: .normal)
        }
    }
    @objc func swipeToStopGesture(recognizer: UISwipeGestureRecognizer){
        
    }
    @objc func centerAction(_ sender: Any) {
        guard let mapVC = controller as? MapViewController else { return }
        mapVC.getCenterMap()
    }
}
