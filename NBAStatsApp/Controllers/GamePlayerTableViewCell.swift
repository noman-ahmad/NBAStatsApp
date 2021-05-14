//
//  GamePlayerTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/13/21.
//

import UIKit

class GamePlayerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var assists: UILabel!
    @IBOutlet weak var blocks: UILabel!
    @IBOutlet weak var ft_pct: UILabel!
    
    @IBOutlet weak var steals: UILabel!
    @IBOutlet weak var rebounds: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDefault() {
        playerName.text = "Player"
        minutes.text = "MIN"
        points.text = "PTS"
        rebounds.text = "REB"
        assists.text = "AST"
        blocks.text = "BLK"
        steals.text = "STL"
        ft_pct.text = "FTS"
        threept.text = "3PT"
    }
    @IBOutlet weak var threept: UILabel!
    
    func configurePlayerStat(forPlayerStat: GameStats){
        let realName = forPlayerStat.player!.first_name.prefix(1) + "." + forPlayerStat.player!.last_name
        playerName.text = realName
        var formatted_min = ""
        if forPlayerStat.min == "" || forPlayerStat.min == "0:00"{
            formatted_min = "DNP"
            minutes.text = formatted_min
            points.text = ""
            assists.text = ""
            rebounds.text = ""
            steals.text = ""
            blocks.text = ""
            ft_pct.text  = ""
            threept.text = ""
        } else {
            let start_min = forPlayerStat.min.index(forPlayerStat.min.startIndex, offsetBy: 0)
            var end_min = forPlayerStat.min.index(forPlayerStat.min.startIndex, offsetBy: 1)
            if forPlayerStat.min[end_min] == ":" {
                end_min = forPlayerStat.min.index(forPlayerStat.min.startIndex, offsetBy: 0)
            }
            let range = start_min...end_min
            formatted_min = String(forPlayerStat.min[range])
            minutes.text = formatted_min
            points.text = String(forPlayerStat.pts)
            assists.text = String(forPlayerStat.ast)
            rebounds.text = String(forPlayerStat.reb)
            steals.text = String(forPlayerStat.stl)
            blocks.text = String(forPlayerStat.blk)
            ft_pct.text  = String(forPlayerStat.ftm) + "/" + String(forPlayerStat.fta)
            threept.text = String(forPlayerStat.fg3m) + "/" + String(forPlayerStat.fg3a)
        }
    }
    
    

}
