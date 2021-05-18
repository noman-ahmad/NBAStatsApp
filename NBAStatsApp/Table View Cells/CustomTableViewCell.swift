//
//  CustomTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/5/21.
//

import UIKit
import Kingfisher

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
        teamImage.kf.setImage(with: url)
    }
    
    func configurePlayer(forPlayer: PlayerInfo) {
        NameLabel.text = forPlayer.first_name + " " + forPlayer.last_name
        var playerurl = forPlayer.imageUrl
        if playerurl == nil {
            playerurl = ""
        }
        let url = URL(string: playerurl!)
        print(url)
        let processor = DownsamplingImageProcessor(size: teamImage.bounds.size)
        //teamImage.kf.indicatorType = .activity
        teamImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "default-headshot-men.png"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
