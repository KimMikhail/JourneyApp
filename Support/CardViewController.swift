//
//  CardViewController.swift
//  Journey
//
//  Created by  Mikhail on 15.03.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    var controller: UIViewController!
    private var superview: UIView!
    var handleArea: UIView!
    private var handleAreaHeight: CGFloat = 20
    private var cardHeight: CGFloat = 250
    private var heightInCollapsedState: CGFloat = 20
    private var duration: Double = 1
    private var cardVisible = false
    private var cornerRadius: CGFloat = 12
    
    enum CardState {
        case expanded
        case collapsed
    }
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var runningAnnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    init (controller: UIViewController, superview: UIView, handleAreaHeight: CGFloat, cardHeight: CGFloat, heightInCollapsedState: CGFloat) {
        self.controller = controller
        self.superview = superview
        superview.clipsToBounds = true
        self.handleAreaHeight = handleAreaHeight
        self.cardHeight = cardHeight
        self.heightInCollapsedState = heightInCollapsedState
        self.handleArea = UIView(frame: CGRect(x: 0, y: 0, width: superview.bounds.width, height: handleAreaHeight))
        super.init(nibName: nil, bundle: nil)
        setup()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.view.frame = CGRect(x: 0, y: superview.frame.height - heightInCollapsedState, width: superview.frame.width, height: cardHeight)
        self.view.clipsToBounds = true
        superview.addSubview(self.view)
        controller.addChild(self)
        self.view.addSubview(handleArea)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleAreaTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleAreaPan(recognizer:)))
        
        self.handleArea.addGestureRecognizer(tapGestureRecognizer)
        self.handleArea.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handleAreaTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: duration)
        default:
            break
        }
    }
    @objc func handleAreaPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: duration)
        case .changed:
            let translation = recognizer.translation(in: self.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.view.frame.origin.y = self.superview.frame.height - self.view.frame.height
                case .collapsed:
                    self.view.frame.origin.y = self.superview.frame.height - self.heightInCollapsedState
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible.toggle()
                self.runningAnnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.view.layer.cornerRadius = self.cornerRadius
                    self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                case .collapsed:
                    self.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnnimations.append(cornerRadiusAnimator)
        }
    }
    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    private func continueInteractiveTransition() {
        for animator in runningAnnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    func setupTransitionDuration(timeInterval: Double) {
        // Check value here
        self.duration = timeInterval
    }
    func setupCornerRadius(radius: CGFloat) {
        // Check value here
        self.cornerRadius = radius
    }
    func setupHandleAreaHeight(height: CGFloat) {
        // Check value here
        self.handleAreaHeight = height
    }
    func setupCardHeight(height: CGFloat) {
        // Check value here
        self.cardHeight = height
    }
}
