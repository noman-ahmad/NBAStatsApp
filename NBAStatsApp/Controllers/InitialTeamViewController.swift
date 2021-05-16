//
//  InitialTeamViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/26/21.
//

import UIKit
import AVFoundation

class InitialTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var audio_player = AVAudioPlayer() 
    // MARK: - Outlets & Variables
    @IBOutlet weak var teamTableView: UITableView!
    var teams = [TeamInfo]()
    var players:[PlayerInfo]?
    
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

        self.navigationItem.title = "Pick A Team"
        downloadTeamData {
            self.teamTableView.reloadData()
        }
        teamTableView.delegate = self
        teamTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.configure(forTeam: self.teams[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTeamDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TeamViewController {
            destination.currentTeam = teams[(teamTableView.indexPathForSelectedRow?.row)!]
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
    func downloadTeamData(completed: @escaping () -> ()) {
        let url = URL(string: "https://www.balldontlie.io/api/v1/teams")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    let result = try JSONDecoder().decode(TeamData.self, from: data!)
                    for data in result.data {
                        self.teams.append(data)
                    }
                    DispatchQueue.main.async{
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




