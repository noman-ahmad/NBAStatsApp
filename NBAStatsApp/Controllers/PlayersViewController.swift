//
//  PlayersViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/30/21.
//

import UIKit
import AVFoundation

class PlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var audio_player = AVAudioPlayer()
    // MARK: - Outlets & Variables
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var playersTableView: UITableView!
    
    var players = [PlayerInfo]()
    
    var allPlayers: [PlayerInfo]?
    
    var currentTeam : TeamInfo?
    
    var allPlayerStats = [PlayerStats]()
    
    var playerToSend = [PlayerStats]()
    
    
    // MARK: - On Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let colors_on = defaults.bool(forKey: "dark_mode")
        if colors_on {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        self.navigationItem.title = currentTeam?.full_name
        let imageUrl = ("http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + (currentTeam?.abbreviation.lowercased())! + ".png")
        let url = URL(string: imageUrl)
        teamImageView.downloaded(from: imageUrl)
        print(currentTeam?.abbreviation as Any)
//        self.getPlayerforTeam {
//            print("Got All Players")
//            self.playersTableView.delegate = self
//            self.playersTableView.dataSource = self
//            print(self.players)
//        }
//        self.downloadAllSeasonStatsData() {
//        }

            // Put your code which should be executed with a delay here
        self.playersTableView.reloadData()
        // Do any additional setup after loading the view.
        playersTableView.delegate = self
        playersTableView.dataSource = self
//        print(players)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.configurePlayer(forPlayer: players[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Put your code which should be executed with a delay here
        self.performSegue(withIdentifier: "playerStats", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayerStatsViewController {
            destination.currentPlayer = players[(playersTableView.indexPathForSelectedRow?.row)!]
            destination.currentPlayerStats = allPlayerStats
        }
        let defaults = UserDefaults.standard
        let sound_on = defaults.bool(forKey: "sounds")
        if sound_on {
            let sound = Bundle.main.path(forResource: "swoosh", ofType: ".mp3")
            do {
                audio_player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            } catch {
                debugPrint(error)
            }
            audio_player.play()
        }

    }
    
//    func getPlayerforTeam(completed: @escaping () -> ()) {
//        for i in 0...allPlayers!.count-1 {
//            let currentPlayer = allPlayers![i]
//            if currentPlayer.team.id == self.currentTeam!.id {
//                let roster = TeamsPlayers[self.currentTeam!.full_name]
//                for j in 0...roster!.count-1{
//                    if roster![j] == currentPlayer.id{
//                        players.append(currentPlayer)
//                    }
//                }
//            }
//        }
//        players.sort(by: {$0.last_name < $1.last_name})
//        DispatchQueue.main.async {
//            completed()
//        }
//    }
//
//
//
//    // MARK: - API Functionality
//    func downloadStatsData(season: Int, completed: @escaping () -> ()) {
//       var baseurl = "https://www.balldontlie.io/api/v1/season_averages?season=" + String(season)
//        for i in 0...players.count-1 {
//            baseurl = baseurl + "&player_ids[]=" + String(players[i].id)
//        }
//        let url = URL(string: baseurl)
//        URLSession.shared.dataTask(with: url!) {
//            (data, response, error) in
//            // if data is available
//            if error == nil {
//                do {
//                    let result = try JSONDecoder().decode(StatsData.self, from: data!)
//                    for data in result.data {
//                        self.allPlayerStats.append(data)
//                        //print(data)
//                    }
//                    DispatchQueue.main.async {
//                        completed()
//                    }
//                } catch {
//                    print("API CALL Limit")
//                    //debugPrint(error)
//                }
//            }
//        }.resume()
//    }
//
//    func downloadAllSeasonStatsData(completed: @escaping () -> ()) {
//        for i in 0...20  {
//            downloadStatsData(season: 2020 - i) {
//                print("Got Data For Season: ")
//                self.allPlayerStats.sort(by: {$0.season > $1.season})
//            }
//        }
//        DispatchQueue.main.async {
//            completed()
//        }
//    }
//
//
    
    
// MARK: - DEBUG CODE
//    // MARK: - API Functionality
//    func downloadPlayerData(page: Int, completed: @escaping () -> ()) {
//        let url = URL(string: ("https://www.balldontlie.io/api/v1/players?per_page=100&page=") + String(page))
//
//        URLSession.shared.dataTask(with: url!) {
//            (data, response, error) in
//
//            if error == nil {
//                do {
//                    let result = try JSONDecoder().decode(PlayerData.self, from: data!)
//                    for data in result.data {
//                        if data.team.id == self.currentTeam!.id {
//                            let roster = TeamsPlayers[self.currentTeam!.full_name]
//                            for i in 0...roster!.count-1{
//                                if roster![i] == data.id{
//                                    self.players.append(data)
//                                    print(self.players)
//                                }
//                            }
//                        }
//                    }
//                    DispatchQueue.main.async{
//                        completed()
//                    }
//                } catch {
//                    debugPrint(error)
//                }
//            }
//        }.resume()
//    }
//
//    func downloadAllPlayerData(){
//        for i in 1...35 {
//            downloadPlayerData(page: i) {
//                print("Successfully Download Page" + String(i))
//                self.playersTableView.reloadData()
//                }
//        }
//    }
    

}
