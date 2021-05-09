//
//  ViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/26/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var audio_player = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadAllPlayerData()
        let defaults = UserDefaults.standard
        let colors_on = defaults.bool(forKey: "color")
        self.InitialButton.isEnabled = false
        self.ColorSwitch.setOn(colors_on, animated: false)
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.InitialButton.isEnabled = true
        }
        
    }
    @IBOutlet weak var ColorSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InitialTeamViewController {
            destination.players = allPlayers
        }
        let sound = Bundle.main.path(forResource: "swoosh", ofType: ".mp3")
        do {
            audio_player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            debugPrint(error)
        }
        audio_player.play()
    }
    

    @IBAction func toggleColor(_ sender: Any) {
        if self.ColorSwitch.isOn {
            let defaults = UserDefaults.standard
            var colors_on = defaults.bool(forKey: "color")
            colors_on.toggle()
            defaults.set(colors_on, forKey: "color")
            self.ColorSwitch.setOn(colors_on, animated: true)
            print(defaults.bool(forKey: "color"))
        } else {
            let defaults = UserDefaults.standard
            var colors_on = defaults.bool(forKey: "color")
            colors_on.toggle()
            defaults.set(colors_on, forKey: "color")
            self.ColorSwitch.setOn(colors_on, animated: true)
            print(defaults.bool(forKey: "color"))
        }
    }
    @IBOutlet weak var InitialButton: UIButton!
    
    var allPlayers = [PlayerInfo]()
    var pages = 35
    var player_count = 0
    
    func downloadPlayerData(page: Int, completed: @escaping () -> ()) {
        let url = URL(string: ("https://www.balldontlie.io/api/v1/players?per_page=100&page=") + String(page))
        
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            if error == nil {
                do {
                    let result = try JSONDecoder().decode(PlayerData.self, from: data!)
                    self.pages = result.meta.total_pages
                    self.player_count = result.meta.total_count
                    for data in result.data {
                        self.allPlayers.append(data)
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
    
    func downloadAllPlayerData(){
        for i in 1...self.pages {
            downloadPlayerData(page: i) {
                print("Successfully Download Page" + String(i))
                }
        }
    }
    
}

