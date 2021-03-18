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
    var viewToStop: UIView!
    var startButtonFrame: CGRect!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    var animations = [UIViewPropertyAnimator]()
    override func viewDidLoad() {
        super.viewDidLoad()
        appendButtonsToHandleArea()
    }
    func appendButtonsToHandleArea() {
        startButtonFrame = CGRect(x: handleArea.bounds.width / 2 - 60, y: 0, width: 120, height: 30)
        startRouteButton = UIButton(frame: startButtonFrame)
        let centerButtonFrame = CGRect(x: handleArea.bounds.width - 12 - 30, y: 12, width: 30, height: 30)
        centerButton = UIButton(frame: centerButtonFrame)
        let viewToStopBySwipeFrame = CGRect(x: 6, y: 12, width: handleArea.frame.width - centerButton.frame.width - 30, height: 30)
        viewToStop = UIView(frame: viewToStopBySwipeFrame)
        
        handleArea.addSubview(viewToStop)
        viewToStop.addSubview(startRouteButton)
        
        
        
        startRouteButton.tintColor = .white
        startRouteButton.layer.cornerRadius = 12
        startRouteButton.clipsToBounds = true
        startRouteButton.setTitle("Start", for: .normal)
        startRouteButton.setTitleColor(UIColor(white: 1, alpha: 0.4), for: .highlighted)
        startRouteButton.layer.borderWidth = 1
        startRouteButton.layer.borderColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        startRouteButton.addTarget(self, action: #selector(startRouteAction(_:)), for: .touchUpInside)
        
        
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
        UIView.animate(withDuration: 0.5) {
            button.frame.origin.x = 0
            button.setTitle("|| ->>>", for: .normal)
            button.layer.borderWidth = 0
            self.setPanGesture()
        }
    }
    private func setPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panToStop(recognizer:)))
        startRouteButton.addGestureRecognizer(panGestureRecognizer)
    }
    @objc func panToStop(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            startInteractiveTransition(recognizer: recognizer)
        case .changed:
            let translation = recognizer.translation(in: viewToStop)
            let fractionCompleted = translation.x / startRouteButton.bounds.width / 2
            updateInteractiveTransition(fractionCompleted: fractionCompleted)
        case .ended:
            endInteractiveTransition(recognizer: recognizer)
        default:
            break
        }
    }
    @objc func centerAction(_ sender: Any) {
        guard let mapVC = controller as? MapViewController else { return }
        mapVC.getCenterMap()
    }
    
    private func startInteractiveTransition(recognizer: UIPanGestureRecognizer) {
        if animations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
                self.startRouteButton.frame.origin.x = self.viewToStop.frame.width - self.startRouteButton.frame.width
            }
            frameAnimator.addCompletion { _ in
                self.animations.removeAll()
            }
            frameAnimator.startAnimation()
            animations.append(frameAnimator)
        }
        for animator in animations {
            animator.pauseAnimation()
        }
    }
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in animations {
            animator.fractionComplete = fractionCompleted
        }
        
    }
    private func endInteractiveTransition(recognizer: UIPanGestureRecognizer) {
        
        
        let frameAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) { [self] in
            if self.animations.first!.fractionComplete < 1{
            self.startRouteButton.frame.origin.x = 0
            }
        }
        frameAnimator.addCompletion { _ in
            self.animations.removeAll()
        }
        frameAnimator.startAnimation()
        
        if animations.first?.fractionComplete == 1 {
            guard let mapVC = controller as? MapViewController else { return }
            mapVC.saveRoute()
            mapVC.isOnTheWay = false
            startRouteButton.gestureRecognizers?.removeAll()
            UIView.animate(withDuration: 0.3) {
                self.startRouteButton.frame = self.startButtonFrame
                self.startRouteButton.setTitle("Start", for: .normal)
                self.startRouteButton.layer.borderWidth = 2
            }
            clearLabels()
            
        }
    }
    private func clearLabels(){
        timeLabel.text = "00:00:00"
        distanceLabel.text = "0"
        speedLabel.text = "0"
        averageSpeedLabel.text = "0"
        stepsLabel.text = "0"
    }
}
