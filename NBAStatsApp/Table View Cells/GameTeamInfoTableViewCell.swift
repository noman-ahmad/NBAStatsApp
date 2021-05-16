//
//  GameTeamInfoTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/13/21.
//

import UIKit

class GameTeamInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var homeTeamScore: UILabel!
    @IBOutlet weak var homeTeamImage: UIImageView!
    
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var awayTeamScore: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var homeRecord: UILabel!
    
    @IBOutlet weak var awayRecord: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var outcomeLabel: UILabel!
    @IBOutlet weak var seasonLogo: UIImageView!
    
    func configureTeamGameInfo(forGame: GameInfo) {
        homeTeamName.text = forGame.home_team!.abbreviation
        homeTeamScore.text = String(forGame.home_team_score!)
        let hteamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forGame.home_team!.abbreviation).lowercased())" + ".png"
        let hurl = URL(string: hteamurl)
        homeTeamImage.load2(url: hurl!, placeholder: nil)
        
        
        awayTeamName.text = forGame.visitor_team!.abbreviation
        awayTeamScore.text = String(forGame.visitor_team_score!)
        let ateamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forGame.visitor_team!.abbreviation).lowercased())" + ".png"
        let aurl = URL(string: ateamurl)
        awayTeamImage.load2(url: aurl!, placeholder: nil)
        
        let start_date = forGame.date!.index(forGame.date!.startIndex, offsetBy: 5)
        let end_date = forGame.date!.index(forGame.date!.startIndex, offsetBy: 9)
            let range = start_date...end_date
            let formatted_date = String(forGame.date![range])
        let newString = formatted_date.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
        
        if (forGame.status != "Final") {
            outcomeLabel.text = "IP " + String(forGame.period!) + "Q"
            outcomeLabel.textColor = .systemOrange
        } else if forGame.period != 4{
            outcomeLabel.text = "Final/OT"
        } else {
            outcomeLabel.text = "Final"
        }
        dateLabel.text = newString
        homeRecord.text = forGame.visitor_team?.division
        homeRecord.textColor = .systemGray
        awayRecord.text = forGame.home_team?.division
        awayRecord.textColor = .systemGray
        
        if forGame.postseason == true {
            seasonLogo.image = #imageLiteral(resourceName: "playoffs1")
        } else {
            seasonLogo.image = #imageLiteral(resourceName: "nba-logo-1")
        }
        
    }

}
