//
//  PlayersViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/30/21.
//

import UIKit
import AVFoundation

class PlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterPositionDelegate{
    var audio_player = AVAudioPlayer()
    // MARK: - Outlets & Variables
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var playersTableView: UITableView!
    
    var players = [PlayerInfo]()
    
    var allPlayers: [PlayerInfo]?
    
    var currentTeam : TeamInfo?
    
    var allPlayerStats = [PlayerStats]()
    
    var playerToSend = [PlayerStats]()
    
    var filtered = false
    
    var filters = [Bool]()
    
    var filteredPlayers = [PlayerInfo]()
    
    
    // MARK: - On Load
    override func viewDidLoad() {
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

        self.navigationItem.title = currentTeam?.full_name
        let imageUrl = ("http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + (currentTeam?.abbreviation.lowercased())! + ".png")
        let url = URL(string: imageUrl)
        teamImageView.downloaded(from: imageUrl)
        print(currentTeam?.abbreviation as Any)

        // Put your code which should be executed with a delay here
        self.playersTableView.reloadData()
        // Do any additional setup after loading the view.
        playersTableView.delegate = self
        playersTableView.dataSource = self
//        print(players)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered {
            return filteredPlayers.count
        } else {
            return players.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filtered {
            let cell = playersTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            cell.configurePlayer(forPlayer: filteredPlayers[indexPath.row])
            return cell
        } else {
            let cell = playersTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            cell.configurePlayer(forPlayer: players[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Put your code which should be executed with a delay here
        self.performSegue(withIdentifier: "playerStats", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PositionFilterViewController {
            destination.delegate = self
            self.filteredPlayers.removeAll()
        }
        
        if let destination = segue.destination as? PlayerStatsViewController {
            if filtered {
                destination.currentPlayer = filteredPlayers[(playersTableView.indexPathForSelectedRow?.row)!]
                destination.currentPlayerStats = allPlayerStats
            } else {
                destination.currentPlayer = players[(playersTableView.indexPathForSelectedRow?.row)!]
                destination.currentPlayerStats = allPlayerStats
            }
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
    
    func addFilter(positions: [Bool]) {
        self.filters = positions
        print("I'm Here")
        for i in 0...self.players.count-1 {
            if positions[0] == true {
                filtered = false
//                filteredPlayers = players
            } else {
                if positions[1] == true && self.players[i].position == "G"{
                    self.filteredPlayers.append(self.players[i])
                }
                if positions[2] == true && self.players[i].position == "G-F"{
                    self.filteredPlayers.append(self.players[i])
                }
                if positions[3] == true && self.players[i].position == "F"{
                    self.filteredPlayers.append(self.players[i])
                }
                if positions[4] == true && self.players[i].position == "F-C"{
                    self.filteredPlayers.append(self.players[i])
                }
                if positions[5] == true && self.players[i].position == "C"{
                    self.filteredPlayers.append(self.players[i])
                }
                self.filtered = true
            }
            if (positions[0] == false) && (positions[1] == false) && (positions[2] == false) && (positions[3] == false) && (positions[4] == false) && (positions[5] == false) {
                self.filtered = false
            }
            self.playersTableView.reloadData()
        }
    }
}

//extension PlayersViewController: FilterPositionDelegate {
//    func addFilter(positions: [Bool]) {
//        self.dismiss(animated:true) {
//            self.filters = positions
//            for i in 0...self.players.count {
//                if positions[0] == true {
//                    return
//                } else {
//                    if positions[1] == true && self.players[i].position == "G"{
//                        self.filteredPlayers.append(self.players[i])
//                    }
//                    if positions[2] == true && self.players[i].position == "G-F"{
//                        self.filteredPlayers.append(self.players[i])
//                    }
//                    if positions[3] == true && self.players[i].position == "F"{
//                        self.filteredPlayers.append(self.players[i])
//                    }
//                    if positions[4] == true && self.players[i].position == "F-C"{
//                        self.filteredPlayers.append(self.players[i])
//                    }
//                    if positions[5] == true && self.players[i].position == "C"{
//                        self.filteredPlayers.append(self.players[i])
//                    }
//                    self.filtered = true
//                    self.playersTableView.reloadData()
//                }
//            }
//        }
//    }
//}
