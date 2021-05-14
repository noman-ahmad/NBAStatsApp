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
        let colors_on = defaults.bool(forKey: "dark_mode")
        let sound_on = defaults.bool(forKey: "sounds")
        self.InitialButton.isEnabled = false
        self.ColorSwitch.setOn(colors_on, animated: false)
        self.SoundSwitch.setOn(sound_on, animated: false)
        if colors_on{
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.InitialButton.isEnabled = true
        }
        
    }
    @IBOutlet weak var SoundSwitch: UISwitch!
    @IBOutlet weak var ColorSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InitialTeamViewController {
            destination.players = allPlayers
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
    

    @IBAction func toggleColor(_ sender: Any) {
        if self.ColorSwitch.isOn {
            let defaults = UserDefaults.standard
            var colors_on = defaults.bool(forKey: "dark_mode")
            colors_on.toggle()
            defaults.set(colors_on, forKey: "dark_mode")
            self.ColorSwitch.setOn(colors_on, animated: true)
            print(defaults.bool(forKey: "dark_mode"))
        } else {
            let defaults = UserDefaults.standard
            var colors_on = defaults.bool(forKey: "dark_mode")
            colors_on.toggle()
            defaults.set(colors_on, forKey: "dark_mode")
            self.ColorSwitch.setOn(colors_on, animated: true)
            print(defaults.bool(forKey: "dark_mode"))
        }
           // Create the action buttons for the alert.
           let defaultAction = UIAlertAction(title: "Agree",
                                style: .default) { (action) in
            // Respond to user selection of the action.
           }
           
           // Create and configure the alert controller.
           let alert = UIAlertController(title: "Dark Mode",
                 message: "Dark Mode has changed",
                 preferredStyle: .alert)
           alert.addAction(defaultAction)
                
           self.present(alert, animated: true) {
              // The alert was presented
           }
        
        if self.ColorSwitch.isOn {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func toggleSound(_ sender: Any) {
        if self.SoundSwitch.isOn {
            let defaults = UserDefaults.standard
            var sound_on = defaults.bool(forKey: "sounds")
            sound_on.toggle()
            defaults.set(sound_on, forKey: "sounds")
            self.SoundSwitch.setOn(sound_on, animated: true)
           print(defaults.bool(forKey: "sounds"))
        } else {
            let defaults = UserDefaults.standard
            var sound_on = defaults.bool(forKey: "sounds")
            sound_on.toggle()
            defaults.set(sound_on, forKey: "sounds")
            self.SoundSwitch.setOn(sound_on, animated: true)
            print(defaults.bool(forKey: "sounds"))
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

