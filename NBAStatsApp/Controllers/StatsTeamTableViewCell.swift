//
//  StatsTeamTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/13/21.
//

import UIKit

class StatsTeamTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var teamImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(forTeam: TeamInfo){
        teamName.text = forTeam.name
        let teamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forTeam.abbreviation).lowercased())" + ".png"
        let url = URL(string: teamurl)
        teamImage.load2(url: url!, placeholder: nil)
    }
    
    

}
