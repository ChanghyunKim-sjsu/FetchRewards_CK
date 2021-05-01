//
//  EventTableViewCell.swift
//  FetchRewards
//
//  Created by 김창현 on 4/22/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLayout() {
        self.eventImageView.layer.cornerRadius = self.eventImageView.frame.width / 8
        self.eventImageView.clipsToBounds = true
        
        if let data = UserDefaults.standard.value(forKey: "\(self.eventNameLabel.text!)") as? Data {
            let event = try? PropertyListDecoder().decode(saveFavoriteEvent.self, from: data)
            if (event!.fav) { self.favImageView.isHidden = false}
            else { self.favImageView.isHidden = true }
        }
        
    }

}
