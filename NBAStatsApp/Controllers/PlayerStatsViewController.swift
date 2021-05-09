//
//  PlayerStatsViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/2/21.
//

import UIKit

class PlayerStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var teamImage: UIImageView!
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerHeight: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerTeam: UILabel!
    @IBOutlet weak var careerStatsLabel: UILabel!
    @IBOutlet weak var careerTableView: UITableView!

    var has_data = true
    
    var currentPlayerStats: [PlayerStats]?
    
    var currentPlayer:PlayerInfo?
    let currentSeason = 2020
    var playerStats = [PlayerStats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = (currentPlayer!.first_name + " " + currentPlayer!.last_name)
        self.playerName.text = currentPlayer!.first_name + " " + currentPlayer!.last_name
        self.playerTeam.text = currentPlayer?.team.full_name
        self.careerStatsLabel.text = "Career Stats"
       // self.playerHeight.text = String((currentPlayer?.height_feet)!) + " ' " + String((currentPlayer?.height_inches)!)
        self.playerImage.downloaded(from: ("https://nba-players.herokuapp.com/players/" + (currentPlayer?.last_name.lowercased())! + "/" + (currentPlayer?.first_name.lowercased())!) )
        self.teamImage.downloaded(from: "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((currentPlayer?.team.abbreviation)!.lowercased())" + ".png")
        if self.currentPlayer?.position == "" {
            self.playerPosition.font = UIFont(name: "System", size: 18)
            self.playerPosition.text = "Unknown Position"
        } else {
            self.playerPosition.text = self.currentPlayer?.position
        }
        let seconds = 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.getCurrentData {
                print("Got Player Data")
            }
            self.careerTableView.delegate = self
            self.careerTableView.dataSource = self
            self.careerTableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStats.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaults = UserDefaults.standard
        let color_on = defaults.bool(forKey: "color")
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Season               Pts      Reb      Ast      Stl      Blk      Ft"
        } else {
            let label = String(playerStats[indexPath.row-1].season) + "-" + String(playerStats[indexPath.row-1].season + 1) + "         " +  String(((playerStats[indexPath.row-1].pts) * 10).rounded() / 10) + "    " + String(((playerStats[indexPath.row-1].reb) * 10).rounded() / 10) + "       " +   String(((playerStats[indexPath.row-1].ast) * 10).rounded() / 10) + "       " +
                String(((playerStats[indexPath.row-1].stl) * 10).rounded() / 10) + "    " + String(((playerStats[indexPath.row-1].blk) * 10).rounded() / 10) + "    " + String(((playerStats[indexPath.row-1].ft_pct * 100) * 1).rounded() / 1)
            cell.textLabel?.text = label
        }
        if color_on {
            cell.textLabel?.textColor = UIColor.blue
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
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
    
    
    
// MARK: - DEBUG CODE
    
//    // MARK: - API Functionality
//    func downloadStatsData(season: Int, completed: @escaping () -> ()) {
//        let url = URL(string: ("https://www.balldontlie.io/api/v1/season_averages?player_ids[]=" + String(currentPlayer!.id) + "&season=" + String(season)))
//        URLSession.shared.dataTask(with: url!) {
//            (data, response, error) in
//
//            if error == nil {
//                do {
//                    let result = try JSONDecoder().decode(StatsData.self, from: data!)
//                    for data in result.data {
//                        self.playerStats.append(data)
//                        print(data)
//                    }
//                    DispatchQueue.main.async {
//                        completed()
//                    }
//                } catch {
//                    debugPrint(error)
//                }
//            }
//        }.resume()
//    }
//
//    func downloadAllSeasonStatsData() {
//        for i in 0...22  {
//            downloadStatsData(season: currentSeason - i) {
//                print("Got Data For Season: ")
//                self.playerStats.sort(by: {$0.season > $1.season})
//                self.careerTableView.reloadData()
//            }
//        }
//    }
    
}
