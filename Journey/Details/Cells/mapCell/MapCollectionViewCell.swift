//
//  MapCollectionViewCell.swift
//  Journey
//
//  Created by  Mikhail on 07.04.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import UIKit
import MapKit

class MapCollectionViewCell: UICollectionViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 10
        renderer.strokeColor = .blue
        renderer.alpha = 0.5
        return renderer
    }

}

