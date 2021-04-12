//
//  PhotosView.swift
//  Journey
//
//  Created by  Mikhail on 09.04.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import UIKit

class PhotosView: UIView {

    var stackView = UIStackView()
    var scrollView = UIScrollView()
    
    override func draw(_ rect: CGRect) {
        setupScrollView()
        setupStackView()
    }
    private func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.isPagingEnabled = true
    }
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
    }
    func addView(with view: UIImageView) {
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2).isActive = true
        stackView.addArrangedSubview(view)
    }

}
