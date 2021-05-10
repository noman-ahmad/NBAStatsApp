//
//  PlayerInfoTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/9/21.
//

import UIKit

class PlayerInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var playerHeight: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerWeight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurePlayerInfo(forPlayer: PlayerInfo) {
        playerName.text = forPlayer.first_name + " " + forPlayer.last_name
        if forPlayer.position == "" {
            playerPosition.text = "Position: Unknown"
        } else {
            playerPosition.text = "Position: " + forPlayer.position!
        }
        if forPlayer.height_feet == nil {
            playerHeight.text = "Height: Unknown"
        } else {
            playerHeight.text = "Height: " +  String(forPlayer.height_feet!) + "\"" + String(forPlayer.height_inches!)
        }
        if forPlayer.weight_pounds == nil {
            playerWeight.text = "Weight: Unknown"
        } else {
            playerWeight.text = "Weight: " +  String(forPlayer.weight_pounds!) + " lbs "
        }
        let playerurl = "https://nba-players.herokuapp.com/players/" + forPlayer.last_name.lowercased() + "/" + forPlayer.first_name.lowercased()
        
        if let url = URL(string: playerurl) {
            playerImage.downloaded(from: playerurl)
        } else {
            playerImage.image = #imageLiteral(resourceName: "default-headshot-men.png")
        }
        
        let teamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forPlayer.team.abbreviation).lowercased())" + ".png"
        let url2 = URL(string: teamurl)
        teamImage.downloaded(from: teamurl)
    }

}
