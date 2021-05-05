//
//  MainViewController.swift
//  FetchRewards
//
//  Created by Changhyun Kim on 4/22/21.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    weak var eventDetailVC: EventDetailViewController?
//    var session : URLSession!
    let colorHex = ColorWithHexString()
    let formatter = DateFormatter()
    
    // Array variable for each events
    lazy var eventList: [EventVO] = {
        var list = [EventVO]()
        return list
    }()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var conTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.conTableView.delegate = self
        self.conTableView.dataSource = self
        
        self.searchBar.delegate = self
        
        // Setup the background color with hex string
        self.topView.backgroundColor = colorHex.hexStringToUIColor(hex: "253544")
        UISearchBar.appearance().setImage(UIImage(named: "icon_search_white.png"), for: .search, state: .normal)
        
        self.setData(searching: "?")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // White Space will be replaced with +
        let newEvent = searchBar.text!.replacingOccurrences(of: " ", with: "+")
        
        // Clear all data before the new data
        self.eventList.removeAll()
        
        self.setData(searching: "?q=\(newEvent)&")
        self.conTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EventTableViewCell
        let row = self.eventList[indexPath.row]
        let url = URL(string: row.thumbnail!)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.eventImageView.image = UIImage(data: data!)
            }
        }
        cell.contentView.isUserInteractionEnabled = false
        
        // Get and fetch data to the each UITableViewCell
        cell.eventNameLabel.text = row.title
        cell.dateLabel.text = row.date
        cell.locationLabel.text = row.location
        cell.setLayout()
        
        return cell
    }
    
    func setData(searching: String = "") {
        let url = "https://api.seatgeek.com/2/events" + searching + "client_id=" + clientId
        let apiURL: URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURL)
        
        // Get the data with the api and store the data in each eventList object
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            let entireEvent = apiDictionary["events"] as! NSArray
            
            for row in entireEvent {
                let evo = EventVO()
                let r = row as! NSDictionary

                if let date = r["datetime_local"] as? String {
                    evo.date = dateReformat(reDate: date)
                }
                
                let pAry = r["performers"] as! [[String:Any]]
                let performers = pAry[0] as NSDictionary
                
                if let image = performers["image"] as? String {
                    evo.thumbnail = image
                }
                
                if let title = performers["name"] as? String {
                    evo.title = title
                }
                
                let vAry = r["venue"] as! NSDictionary
                if let location = vAry["display_location"] as? String {
                    evo.location = location
                }
                
                self.eventList.append(evo)
            }
            
        }
        catch {
            NSLog("Parse Error!!")
        }
                
    }
    
    // Reforming date format
    func dateReformat(reDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let datee = dateFormatter.date(from: reDate)
        dateFormatter.dateFormat = "EEEE, d MMM yyyy h:mma"
        
        return dateFormatter.string(from: datee!)
    }
    
    @IBAction func cancelBtn(_ sender: Any) { self.searchBar.text = "" }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventDetail" {
            let indexPath = self.conTableView.indexPathForSelectedRow
            guard let index = indexPath?.row else { return }
            let row = self.eventList[index]
            
            let destVC = segue.destination as! EventDetailViewController
            destVC.titleLabel = row.title!
            destVC.dateLabel = row.date!
            destVC.locationLabel = row.location!
            destVC.imageUrlLabel = row.thumbnail!
        }
    }
        
    // Going back to the Main View Controller Scene
    @IBAction func unwindToMain( _ seg: UIStoryboardSegue) {
        self.conTableView.reloadData()
    }
    
}
