//
//  MainCollectionViewCell.swift
//  location_activity
//
//  Created by phattarapon on 22/7/2565 BE.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ativityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confidentLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayHistoryActivity(activity: ActivityForm) {
        self.ativityLabel.text = "กิจกรรม : " + "\(String(describing: activity.activity ?? "-"))"
        self.dateLabel.text = "วันที่เริ่ม : " + "\(String(describing: activity.date ?? "-"))"
        self.confidentLabel.text = "ความเเม่นยำ : " + "\(String(describing: activity.confident ?? "-"))"
        self.speedLabel.text = String(format: "ความเร็ว : %.1f", activity.speed ?? 0.0) + " Km/h"
    }

}
