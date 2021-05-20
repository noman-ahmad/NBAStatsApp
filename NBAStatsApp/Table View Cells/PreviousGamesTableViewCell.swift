//
//  PreviousGamesTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/9/21.
//

import UIKit

class PreviousGamesTableViewCell: UITableViewCell {

    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var playoffsImage: UIImageView!
    
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var outcome: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurePrevGame(forGame: GameInfo, forTeam: TeamInfo) {
        homeName.text = forGame.home_team!.abbreviation
        awayName.text = forGame.visitor_team!.abbreviation
        homeScore.text = String(forGame.home_team_score!)
        awayScore.text = String(forGame.visitor_team_score!)
        
        let hteamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forGame.home_team!.abbreviation).lowercased())" + ".png"
        let hurl = URL(string: hteamurl)
        homeImage.load2(url: hurl!, placeholder: nil)
        
        let ateamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forGame.visitor_team!.abbreviation).lowercased())" + ".png"
        let aurl = URL(string: ateamurl)
        awayImage.load2(url: aurl!, placeholder: nil)
        
        if forGame.status != "Final" {
            outcome.text = "IP: " + String(forGame.period!) + "Q"
            outcome.textColor = .systemOrange
        } else  if forTeam.name == forGame.home_team!.name {
            if (forGame.home_team_score! > forGame.visitor_team_score!) {
                outcome.text = "Final"
                outcome.textColor = .systemGreen
            } else {
                outcome.text = "Final"
                outcome.textColor = .systemRed
            }
        } else {
            if(forGame.home_team_score! > forGame.visitor_team_score!) {
                outcome.text = "Final"
                outcome.textColor = .systemRed
            } else {
                outcome.text = "Final"
                outcome.textColor = .systemGreen
            }
        }
        if forGame.period! > 4 && forGame.status != "Final"{
            outcome.text = outcome.text! + "/OT"
        }
        let start_date = forGame.date!.index(forGame.date!.startIndex, offsetBy: 5)
        let end_date = forGame.date!.index(forGame.date!.startIndex, offsetBy: 9)
            let range = start_date...end_date
            let formatted_date = String(forGame.date![range])
        let newString = formatted_date.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
        dateLabel.text = newString
        
        if forGame.postseason == true {
            playoffsImage.image = #imageLiteral(resourceName: "4741__nba_playoffs-primary_on_dark-2018")
            //playoffsImage.backgroundColor = .black
        } else {
            playoffsImage.isHidden = true
        }
    }

}
