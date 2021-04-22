//
//  MainViewController.swift
//  FetchRewards
//
//  Created by 김창현 on 4/22/21.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let colorHex = ColorWithHexString()
    let postData = PostData()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var conTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topView.backgroundColor = colorHex.hexStringToUIColor(hex: "253544")
        UISearchBar.appearance().setImage(UIImage(named: "icon_search_white.png"), for: .search, state: .normal)
        
        self.conTableView.delegate = self
        self.conTableView.dataSource = self
        
        postData.postDataUrl()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EventTableViewCell
        
        return cell
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) { self.searchBar.text = "" }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
