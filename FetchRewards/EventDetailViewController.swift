//
//  EventDetailViewController.swift
//  FetchRewards
//
//  Created by 김창현 on 4/25/21.
//

import UIKit

struct saveFavoriteEvent: Codable {
    let title: String!
    let fav: Bool!
}

class EventDetailViewController: UIViewController {

    var titleLabel: String = ""
    var dateLabel: String = ""
    var locationLabel: String = ""
    var imageUrlLabel: String = ""
    var favYN: Bool = false
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTitleLabel.text = self.titleLabel
        self.eventDateLabel.text = self.dateLabel
        self.eventLocationLabel.text = self.locationLabel
        
        let url = URL(string: self.imageUrlLabel)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.eventImageView.image = UIImage(data: data!)
            }
        }
        
        self.eventImageView.layer.cornerRadius = self.eventImageView.frame.width / 32 
        self.eventImageView.clipsToBounds = true
        
        if let data = UserDefaults.standard.value(forKey: "\(self.titleLabel)") as? Data {
            let event = try? PropertyListDecoder().decode(saveFavoriteEvent.self, from: data)
            self.favYN = event!.fav
        }
        
        self.favorite()
    }
    
    func favorite() {
        if (!self.favYN) {
            // Unlike
            self.favoriteImageView.image = UIImage(named: "icon_like_tap_30.png")
            
        } else {
            // Like
            self.favoriteImageView.image = UIImage(named: "Like_tapped.png")
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    @IBAction func tapFavorite(_ sender: Any) {
        self.favYN = !self.favYN
        self.favorite()
        
        let event = saveFavoriteEvent(title: self.titleLabel, fav: self.favYN)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(event), forKey: "\(self.titleLabel)")
    }
    
}
