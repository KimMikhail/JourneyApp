//
//  StatisticViewCell.swift
//  Journey
//
//  Created by  Mikhail on 31.03.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import UIKit

class StatisticCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillCell(route: Route) {
        guard let fromDate = route.timeStamps.first,
              let toDate = route.timeStamps.last else { return }
        self.timeLabel.text = getTimeString(timeInterval: fromDate.distance(to: toDate)) as? String
        self.distanceLabel.text = "\(route.distance)"
        self.speedLabel.text = "\(route.averageSpeed)"
        self.stepsLabel.text = "\(route.steps)"
    }

    private func getTimeString(timeInterval: TimeInterval) -> String {
        let ti = Int(timeInterval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds) as String
    }
}
