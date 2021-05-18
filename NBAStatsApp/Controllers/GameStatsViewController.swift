//
//  GameStatsViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/13/21.
//

import UIKit

class GameStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var statsTableView: UITableView!
    var currentGame : GameInfo?
    var players : [PlayerInfo]?
    var allGameStats = [GameStats]()
    var home_indexes = [Int]()
    var away_index = [Int]()
    var homeStats = [GameStats]()
    var awayStats = [GameStats]()
    var isFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = (self.currentGame?.visitor_team!.abbreviation)! + " vs. " + (self.currentGame?.home_team!.abbreviation)!
        
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
        
        downloadGameStatsData {
            print("Got Data")
            
            //self.statsTableView.reloadData()
        }
        statsTableView.dataSource = self
        statsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isFetched {
            return 0
        } else {
            return 5 + allGameStats.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "gameDetails", for: indexPath) as! GameTeamInfoTableViewCell
            cell.configureTeamGameInfo(forGame: currentGame!)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell

        } else if indexPath.row == 1 {
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "teamDetails", for: indexPath) as! StatsTeamTableViewCell
            cell.configure(forTeam: (currentGame?.visitor_team!)!)
            //cell.configurePlayer(forPlayer: players[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if indexPath.row == 2 {
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "statDetails", for: indexPath) as! GamePlayerTableViewCell
            cell.configureDefault()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if (indexPath.row >= 3) && (indexPath.row <= 3 + self.awayStats.count - 1) && (self.isFetched){
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "statDetails", for: indexPath) as! GamePlayerTableViewCell
            cell.configurePlayerStat(forPlayerStat: self.awayStats[indexPath.row-3])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if (indexPath.row == 3 + self.awayStats.count) && self.isFetched{
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "teamDetails", for: indexPath) as! StatsTeamTableViewCell
            cell.configure(forTeam: (currentGame?.home_team!)!)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else if (indexPath.row == 4 + self.awayStats.count) && self.isFetched{
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "statDetails", for: indexPath) as! GamePlayerTableViewCell
            cell.configureDefault()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = statsTableView.dequeueReusableCell(withIdentifier: "statDetails", for: indexPath) as! GamePlayerTableViewCell
            cell.configurePlayerStat(forPlayerStat: self.homeStats[indexPath.row - (5 + awayStats.count)])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    
    
    func downloadGameStatsData(completed: @escaping () -> ()) {
        let gameUrl = "https://www.balldontlie.io/api/v1/stats" + "?game_ids[]=" + String(currentGame!.id) + "per_page=100"
        
        let url = URL(string: gameUrl)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    let result = try JSONDecoder().decode(GameStatsData.self, from: data!)
                    for data in result.data {
                        print(data)
                        if data.team?.abbreviation == self.currentGame?.home_team?.abbreviation {
                            self.home_indexes.append(self.allGameStats.count)
                            self.homeStats.append(data)
                        } else {
                            self.away_index.append(self.allGameStats.count)
                            self.awayStats.append(data)
                        }
                        self.allGameStats.append(data)
                    }
                    self.homeStats.sort(by: {!($0 < $1)})
                    self.awayStats.sort(by: {!($0 < $1)})
                    self.isFetched = true
                    DispatchQueue.main.async{
                        completed()
                        self.statsTableView.reloadData()
                    }
                } catch {
                    //print("API CALL LIMIT")
                    debugPrint(error)
                }
            }
        }.resume()
    }
    
}


