//
//  TeamViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/26/21.
//

import UIKit
import AVFoundation

// MARK: - Extensions
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async() { [weak self] in
                    self?.image = #imageLiteral(resourceName: "defaultplayer")
                }
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var audio_player = AVAudioPlayer()
    // MARK: - Outlets & Variables
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamLogoView: UIImageView!
    @IBOutlet weak var teamRecord: UILabel!
    
    @IBOutlet weak var teamConference: UILabel!
    @IBOutlet weak var teamDivision: UILabel!
    @IBOutlet weak var PlayersButton: UIBarButtonItem!
    @IBOutlet weak var upcomingGame: UILabel!
    @IBOutlet weak var teamAbbr: UILabel!
    
    var games = [GameInfo]()
    var nextGame:GameInfo?
    var wins : Int = 0
    var losses: Int = 0
    var players:[PlayerInfo]?
    
    @IBOutlet weak var recentGames: UILabel!
    @IBOutlet weak var gamesTableView: UITableView!
   
    var currentTeam:TeamInfo?
    
    @IBOutlet weak var nextOpponent: UIImageView!
    
    
    // MARK: - On Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentTeam?.abbreviation
        PlayersButton.title = "See Players"
        
        teamNameLabel.text = currentTeam?.full_name
        
        teamDivision.text = currentTeam!.division + " Division"
        
        teamConference.text = currentTeam!.conference + " Conference"
        
        teamAbbr.text = currentTeam!.abbreviation
        
        recentGames.text = "Games in 2020-21 Season"
        
        
        let imageUrl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((currentTeam?.abbreviation)!.lowercased())" + ".png"
        
        let url = URL(string: imageUrl)
        
        teamLogoView.downloaded(from: url!)
        
        downloadGameData { [self] in
            self.gamesTableView.reloadData()
            teamRecord.text = String(self.wins) + "W-" + String(self.losses) + "L"
            let start_date = nextGame!.date.index(nextGame!.date.startIndex, offsetBy: 5)
            let end_date = nextGame!.date.index(nextGame!.date.startIndex, offsetBy: 9)
            let range = start_date...end_date
            let formatted_date = String(nextGame!.date[range])
            var add_to_label = "Upcoming Game: " + formatted_date
            var opposing_team = ""
            if nextGame?.home_team.id == currentTeam?.id{
                add_to_label = add_to_label + " vs. " + (nextGame?.visitor_team.abbreviation)!
                opposing_team = (nextGame?.visitor_team.abbreviation)!
            } else {
                add_to_label = add_to_label + " @ " + (nextGame?.home_team.abbreviation)!
                opposing_team = (nextGame?.home_team.abbreviation)!
            }
            
            upcomingGame.text = add_to_label
            
            
            let opposingTeamUrl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((opposing_team).lowercased())" + ".png"
            
            let url = URL(string: opposingTeamUrl)
            
            nextOpponent.downloaded(from: url!)
        }
        
        let defaults = UserDefaults.standard
        print(defaults.bool(forKey: "color"))
        
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        
    }
    
    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaults = UserDefaults.standard
        let color_on = defaults.bool(forKey: "color")
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let current_game = games[indexPath.row]
        let month_day = current_game.date
        let start_date = month_day.index(month_day.startIndex, offsetBy: 5)
        let end_date = month_day.index(month_day.startIndex, offsetBy: 9)
        let range = start_date...end_date
        let formatted_date = String(month_day[range])
        var add_to_label = ""
        var color = UIColor.black
        // if it is the home team
        if current_game.home_team.id == currentTeam!.id {
            if current_game.home_team_score > current_game.visitor_team_score {
                add_to_label = formatted_date + ": W vs. " + current_game.visitor_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
                if (color_on == true) {
                    color = UIColor.systemGreen
                }
            } else {
                add_to_label = formatted_date + ": L vs. " + current_game.visitor_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
                if (color_on == true) {
                    color = UIColor.systemRed
                }
            }
        } else {
            if current_game.home_team_score > current_game.visitor_team_score {
                add_to_label = formatted_date + ": L @ " + current_game.home_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
                if (color_on == true) {
                    color = UIColor.systemRed
                }
            } else {
                add_to_label = formatted_date + ": W @ " + current_game.home_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
                if (color_on == true) {
                    color = UIColor.systemGreen
                }
            }
        }
        cell.textLabel?.text = add_to_label
        cell.textLabel?.textColor = color
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayersViewController {
            destination.currentTeam = currentTeam
            destination.allPlayers = self.players
        }
        let sound = Bundle.main.path(forResource: "swoosh", ofType: ".mp3")
        do {
            audio_player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            debugPrint(error)
        }
        audio_player.play()

    }
    
    // MARK: - API Functionality
    func downloadGameData(completed: @escaping () -> ()) {
        let base_url = "https://www.balldontlie.io/api/v1/games?seasons[]=2020&team_ids[]=" + String((currentTeam?.id)!) + "&per_page=100"
        print(base_url)
        
        let url = URL(string: base_url)
        
        URLSession.shared.dataTask(with: url!) { [self]
            (data, response, error) in
            
            if error == nil {
                do {
                    let result = try JSONDecoder().decode(GameData.self, from: data!)
                    for data in result.data {
                        self.games.append(data)
                        if data.home_team.id == currentTeam!.id && data.home_team_score != 0{
                            if data.home_team_score > data.visitor_team_score {
                                self.wins = self.wins + 1
                            } else {
                                self.losses = self.losses + 1
                            }
                        } else if data.home_team.id != currentTeam!.id && data.home_team_score != 0 {
                            if data.visitor_team_score > data.home_team_score {
                                self.wins = self.wins + 1
                            } else{
                                self.losses = self.losses + 1
                            }
                        }
                    }
                    print(self.wins)
                    self.games.sort(by: {$0.date > $1.date})
                    print(self.games[0])
                    
                    for i in 0...self.games.count {
                        if (self.games[i].home_team_score == 0) && (self.games[i+1].home_team_score != 0) {
                            nextGame = self.games[i]
                            break
                        }
                    }
                    self.games.removeAll(where: {$0.home_team_score == 0})
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("API CALL LIMIT")
                    //debugPrint(error)
                }
            }
        }.resume()
        
    }
    
}
