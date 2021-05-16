//
//  PlayerStatsViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/2/21.
//

import UIKit

class PlayerStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statsTableView: UITableView!
    
    var has_data = true
    
    var currentPlayerStats: [PlayerStats]?
    
    var currentPlayer:PlayerInfo?
    let currentSeason = 2020
    var playerStats = [PlayerStats]()
    
    override func viewDidLoad() {
        self.statsTableView.delegate = self
        self.statsTableView.dataSource = self
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let colors_on = defaults.bool(forKey: "dark_mode")
        if colors_on{
            overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            overrideUserInterfaceStyle = .light
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }

        self.navigationItem.title = (currentPlayer!.first_name + " " + currentPlayer!.last_name)
            // Put your code which should be executed with a delay here
        self.getCurrentData {
            print("Got Player Data")
            self.statsTableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStats.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaults = UserDefaults.standard
        let color_on = defaults.bool(forKey: "color")
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerInfo", for: indexPath) as! PlayerInfoTableViewCell
            cell.configurePlayerInfo(forPlayer: currentPlayer!)
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerStats", for: indexPath) as! PlayerStatsTableViewCell
            cell.configureInitial()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerStats", for: indexPath) as! PlayerStatsTableViewCell
            cell.configureStats(forStats: self.playerStats[indexPath.row-2])
            return cell
        }
    }
    
    func getCurrentData(completed: @escaping () -> ()) {
        for i in 0...currentPlayerStats!.count-1{
            if currentPlayerStats![i].player_id == self.currentPlayer!.id {
                playerStats.append(currentPlayerStats![i])
            }
        }
        DispatchQueue.main.async {
            completed()
        }
    }
}
