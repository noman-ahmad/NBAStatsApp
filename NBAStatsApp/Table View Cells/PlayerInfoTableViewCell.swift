//
//  PlayerInfoTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/9/21.
//

import UIKit
import Kingfisher

class PlayerInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    
    @IBOutlet weak var star1: UIImageView!
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
    
    func configurePlayerInfo(forPlayer: PlayerInfo, forStat: PlayerStats) {
        playerName.text = forPlayer.first_name + " " + forPlayer.last_name
        if forPlayer.position == "" {
            playerPosition.text = "Position: N/A"
        } else {
            playerPosition.text = "Position: " + forPlayer.position!
        }
        if forPlayer.height_feet == nil {
            playerHeight.text = "Height: N/A"
        } else {
            playerHeight.text = "Height: " +  String(forPlayer.height_feet!) + "\"" + String(forPlayer.height_inches!)
        }
        if forPlayer.weight_pounds == nil {
            playerWeight.text = "Weight: N/A"
        } else {
            playerWeight.text = "Weight: " +  String(forPlayer.weight_pounds!) + " lbs "
        }
        var playerurl = forPlayer.imageUrl
        if playerurl == nil {
            playerurl = ""
        }
        let url = URL(string: playerurl!)
        print(url)
        let processor = DownsamplingImageProcessor(size: teamImage.bounds.size)
        //playerImage.kf.indicatorType = .activity
        playerImage.kf.setImage(
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
        
        let teamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forPlayer.team!.abbreviation).lowercased())" + ".png"
        let url2 = URL(string: teamurl)
        teamImage.downloaded(from: url2!)
        
        let starPoints = isStar(forStat: forStat, forPlayer: forPlayer)
        
        if starPoints == 1 {
            star1.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
        } else if starPoints == 2 {
            star1.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star2.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
        } else if starPoints == 3 {
            star1.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star2.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star3.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
        } else if starPoints == 4 {
            star1.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star2.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star3.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star4.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
        } else if starPoints == 5 {
            star1.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star2.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star3.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star4.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
            star5.image = #imageLiteral(resourceName: "1200px-Golden_star.svg")
        }
    }
    
    
    func isStar(forStat: PlayerStats, forPlayer: PlayerInfo) -> Int {
        let position = forPlayer.position
        
        if (position == "G") || (position == "G-F") || (position == "F-G") {
            let points = (forStat.pts + (1.2 * forStat.reb) + (1.1 * forStat.ast) + (1.3 * forStat.blk) + (1.1 * forStat.stl))
            if points > 42 {
                return 5
            } else if points > 30 {
                return 4
            } else if points > 20 {
                return 3
            } else if points > 14 {
                return 2
            } else {
                return 1
            }
        } else {
            let points = ( (forStat.pts) + (forStat.reb) + (1.2 * forStat.ast) + (1.3 * forStat.stl) + (1.1 * forStat.blk))
            if points > 42 {
                return 5
            } else if points > 32 {
                return 4
            } else if points > 20 {
                return 3
            } else if points > 14 {
                return 2
            } else {
                return 1
            }
        }
    }
}
