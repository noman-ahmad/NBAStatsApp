//
//  TeamViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/26/21.
//

import UIKit
import AVFoundation

// MARK: - Extensions
var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func load(from urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
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
                    self?.image = #imageLiteral(resourceName: "default-headshot-men")
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
extension UIImageView {
    /// Loads image from web asynchronosly and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func load2(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}


class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var audio_player = AVAudioPlayer()
    // MARK: - Outlets & Variables
    @IBOutlet weak var PlayersButton: UIBarButtonItem!

    var games = [GameInfo]()
    var nextGame:GameInfo?
    var wins : Int = 0
    var losses: Int = 0
    var players:[PlayerInfo]?
    
    var allPlayerStats = [PlayerStats]()
    var teamplayers = [PlayerInfo]()
    

    @IBOutlet weak var gamesTableView: UITableView!
   
    var currentTeam:TeamInfo?
    
    
    
    // MARK: - On Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = currentTeam?.abbreviation
        let defaults = UserDefaults.standard
        let colors_on = defaults.bool(forKey: "dark_mode")
        if colors_on {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        PlayersButton.title = "See Players"
        PlayersButton.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        
        
        downloadGameData {
                // Put your code which should be executed with a delay here
            self.gamesTableView.reloadData()
//            let start_date = nextGame!.date.index(nextGame!.date.startIndex, offsetBy: 5)
//            let end_date = nextGame!.date.index(nextGame!.date.startIndex, offsetBy: 9)
//            let range = start_date...end_date
//            let formatted_date = String(nextGame!.date[range])
//            var add_to_label = "Upcoming Game: " + formatted_date
//            if nextGame?.home_team.id == currentTeam?.id{
//                add_to_label = add_to_label + " vs. " + (nextGame?.visitor_team.abbreviation)!
//            } else {
//                add_to_label = add_to_label + " @ " + (nextGame?.home_team.abbreviation)!
//                opposing_team = (nextGame?.home_team.abbreviation)!
//            }
            
            self.getPlayerforTeam {
                print("Got All Players")
                print(self.teamplayers)
            }
            
            self.downloadAllSeasonStatsData() {
            }
            
            let seconds = 5.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                // Put your code which should be executed with a delay here
                self.PlayersButton.isEnabled = true
            }
            
            let backseconds = 40.0
            DispatchQueue.main.asyncAfter(deadline: .now() + backseconds) {
                // Put your code which should be executed with a delay here
                self.navigationItem.hidesBackButton = false
            }
            
            
            
        }
        
        
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        
    }
    
    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamInfo", for: indexPath) as! TeamInfoTableViewCell
            cell.configure(forTeam: self.currentTeam!, forWins: self.wins, forLosses: self.losses)
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nextGame", for: indexPath) as! NextGameTableViewCell
            if nextGame != nil {
                cell.configureNextGame(forGame: nextGame!)
            }
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "previousGame", for: indexPath) as! PreviousGamesTableViewCell
            cell.configurePrevGame(forGame: games[indexPath.row-2], forTeam: currentTeam!)
            return cell
        }
        
//        let defaults = UserDefaults.standard
//        let color_on = defaults.bool(forKey: "color")
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        let current_game = games[indexPath.row]
//        let month_day = current_game.date
//        let start_date = month_day.index(month_day.startIndex, offsetBy: 5)
//        let end_date = month_day.index(month_day.startIndex, offsetBy: 9)
//        let range = start_date...end_date
//        let formatted_date = String(month_day[range])
//        var add_to_label = ""
//        var color = UIColor.black
//        // if it is the home team
//        if current_game.home_team.id == currentTeam!.id {
//            if current_game.home_team_score > current_game.visitor_team_score {
//                add_to_label = formatted_date + ": W vs. " + current_game.visitor_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
//                if (color_on == true) {
//                    color = UIColor.systemGreen
//                }
//            } else {
//                add_to_label = formatted_date + ": L vs. " + current_game.visitor_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
//                if (color_on == true) {
//                    color = UIColor.systemRed
//                }
//            }
//        } else {
//            if current_game.home_team_score > current_game.visitor_team_score {
//                add_to_label = formatted_date + ": L @ " + current_game.home_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
//                if (color_on == true) {
//                    color = UIColor.systemRed
//                }
//            } else {
//                add_to_label = formatted_date + ": W @ " + current_game.home_team.abbreviation + ": " + String(current_game.visitor_team_score) + "-" +  String(current_game.home_team_score) + "  "
//                if (color_on == true) {
//                    color = UIColor.systemGreen
//                }
//            }
//        }
//        cell.textLabel?.text = add_to_label
//        cell.textLabel?.textColor = color
//        cell.textLabel?.textAlignment = .center
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGameStats", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayersViewController {
            destination.currentTeam = currentTeam
            destination.allPlayers = self.players
            destination.allPlayerStats = self.allPlayerStats
            destination.players = self.teamplayers
        }
        if let destination = segue.destination as? GameStatsViewController {
            destination.currentGame = games[(gamesTableView.indexPathForSelectedRow?.row)!-2]
            destination.players = self.players
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
                        if (data.home_team!.id == currentTeam!.id) && (data.home_team_score! != 0) && (data.period! >= 4){
                            if data.home_team_score! > data.visitor_team_score! {
                                self.wins = self.wins + 1
                            } else {
                                self.losses = self.losses + 1
                            }
                        } else if (data.home_team!.id != currentTeam!.id) && (data.home_team_score != 0) && (data.period! >= 4) {
                            if data.visitor_team_score! > data.home_team_score! {
                                self.wins = self.wins + 1
                            } else{
                                self.losses = self.losses + 1
                            }
                        }
                    }
                    //print(self.wins)
                    self.games.sort(by: {$0.date! > $1.date!})
                    //print(self.games[0])
                    
                    for i in 0...self.games.count {
                        if (self.games[i].home_team_score == 0) && (self.games[i+1].home_team_score != 0) {
                            nextGame = self.games[i]
                            print("Got Next Game")
                            if nextGame == nil {
                                print("Nil")
                            } else {
                                print("Not nil")
                            }
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
    
    func getPlayerforTeam(completed: @escaping () -> ()) {
        for i in 0...players!.count-1 {
            let currentPlayer = players![i]
            if currentPlayer.team!.id == self.currentTeam!.id {
                let roster = TeamsPlayers[self.currentTeam!.full_name]
                for j in 0...roster!.count-1{
                    if roster![j] == currentPlayer.id{
                        teamplayers.append(currentPlayer)
                    }
                }
            }
        }
        teamplayers.sort(by: {$0.last_name < $1.last_name})
        DispatchQueue.main.async {
            completed()
        }
    }
    
    
    
    // MARK: - API Functionality
    func downloadStatsData(season: Int, completed: @escaping () -> ()) {
       var baseurl = "https://www.balldontlie.io/api/v1/season_averages?season=" + String(season)
        for i in 0...teamplayers.count-1 {
            baseurl = baseurl + "&player_ids[]=" + String(teamplayers[i].id)
        }
        let url = URL(string: baseurl)
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            // if data is available
            if error == nil {
                do {
                    let result = try JSONDecoder().decode(StatsData.self, from: data!)
                    for data in result.data {
                        self.allPlayerStats.append(data)
                        //print(data)
                    }
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("API CALL Limit")
                    //debugPrint(error)
                }
            }
        }.resume()
    }
    
    func downloadAllSeasonStatsData(completed: @escaping () -> ()) {
        for i in 0...20  {
            downloadStatsData(season: 2020 - i) {
               // print("Got Data For Season: ")
                self.allPlayerStats.sort(by: {$0.season > $1.season})
            }
        }
        DispatchQueue.main.async {
            completed()
        }
    }
    
}
