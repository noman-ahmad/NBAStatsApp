//
//  TeamInfoTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/9/21.
//

import UIKit

class TeamInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var nbaLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamConference: UILabel!
    @IBOutlet weak var teamDivision: UILabel!
    @IBOutlet weak var teamRecord: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(forTeam: TeamInfo, forWins: Int, forLosses: Int){
        teamName.text = forTeam.full_name
        teamConference.text = forTeam.conference
        teamDivision.text = forTeam.division
        teamRecord.text = String(forWins) + "W-" + String(forLosses) + "L"
        let teamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forTeam.abbreviation).lowercased())" + ".png"
        let url = URL(string: teamurl)
        teamImage.load2(url: url!, placeholder: nil)
        nbaLogo.image = #imageLiteral(resourceName: "nba-logo-1.jpg")
    }

}
