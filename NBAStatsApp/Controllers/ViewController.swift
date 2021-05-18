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
    
    
    var old_images = [203095, 202691, 203503, 1628370, 1629690]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadAllPlayerData()
        self.InitialButton.isEnabled = false
        self.InitialButton.tintColor = UIColor.systemBlue.withAlphaComponent(0.0)
        //self.ColorSwitch.setOn(colors_on, animated: false)
        //self.SoundSwitch.setOn(sound_on, animated: false)
        let defaults = UserDefaults.standard
        let colors_on = defaults.bool(forKey: "dark_mode")
        let sound_on = defaults.bool(forKey: "sounds")
        if sound_on {
            self.SoundSwitch.isOn = true
        } else {
            self.SoundSwitch.isOn = false
        }
        if colors_on{
            self.ColorSwitch.isOn = true
            overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            self.ColorSwitch.isOn = false
            overrideUserInterfaceStyle = .light
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.fetchImageInfo()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        UIView.animate(withDuration: 4) {
                        self.InitialButton.tintColor = UIColor.systemBlue.withAlphaComponent(1.0)
                        self.InitialButton.isEnabled = true
                    }
                self.InitialButton.isEnabled = true
            }
            
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
        
        if self.ColorSwitch.isOn{
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
    
    
    func fetchImageInfo(){
        guard let path = Bundle.main.path(forResource: "players", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let array = json as? [Any] else {return}
            
            for imagePlayer in array {
                var is_old = false
                guard let imageDict = imagePlayer as? [String: Any] else {return}
                guard let first_name = imageDict["firstName"] as? String else {return}
                guard let last_name = imageDict["lastName"] as? String else {return}
                guard let playerId = imageDict["playerId"] as? Int else {return}
                guard let teamId = imageDict["teamId"] as? Int else {return}
                for i in 0...allPlayers.count-1 {
                    if (imageDict["firstName"] as! String == allPlayers[i].first_name) && (imageDict["lastName"] as! String == allPlayers[i].last_name) {
                        for i in 0...old_images.count-1 {
                            if imageDict["playerId"] as? Int == old_images[i] {
                                is_old = true
                                break
                            }
                        }
                        if (!is_old) {
                            let url = "http://static.cms.nba.com/wp-content/uploads/headshots/nba/" + String((imageDict["teamId"] as? Int)!) + "/2020/260x190/" + String((imageDict["playerId"] as? Int)!) + ".png"
                            allPlayers[i].imageUrl = url
                           // print(url + "" + players.first_name)
                        } else {
                            let url = "http://static.cms.nba.com/wp-content/uploads/headshots/nba/" + String((imageDict["teamId"] as? Int)!) + "/2019/260x190/" + String((imageDict["playerId"] as? Int)!) + ".png"
                            allPlayers[i].imageUrl = url
                        }
                        
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
}

