//
//  CustomTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/5/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(forTeam: TeamInfo) {
        NameLabel.text = forTeam.full_name
        let imageUrl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forTeam.abbreviation).lowercased())" + ".png"
        let url = URL(string: imageUrl)
        teamImage.load2(url: url!, placeholder: nil)
    }
    
    func configurePlayer(forPlayer: PlayerInfo) {
        NameLabel.text = forPlayer.first_name + " " + forPlayer.last_name
        let playerurl = "https://nba-players.herokuapp.com/players/" + forPlayer.last_name.lowercased() + "/" + forPlayer.first_name.lowercased()
        if let url = URL(string: playerurl) {
            teamImage.load(from: playerurl)
        } else {
            teamImage.image = #imageLiteral(resourceName: "default-headshot-men")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
