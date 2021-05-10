//
//  PlayerStatsTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/9/21.
//

import UIKit

class PlayerStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var blks: UILabel!
    @IBOutlet weak var stls: UILabel!
    @IBOutlet weak var ast: UILabel!
    @IBOutlet weak var rebs: UILabel!
    @IBOutlet weak var pts: UILabel!
    @IBOutlet weak var season: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var ft_pct: UILabel!
    @IBOutlet weak var threepct: UILabel!
    @IBOutlet weak var fgpct: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureInitial() {
        season.text = "Season"
        pts.text = "Pnts"
        ast.text = "Asts"
        rebs.text = "Rebs"
        stls.text = "Stls"
        blks.text = "Blks"
        ft_pct.text = "Ft"
        threepct.text = "3Fg"
        fgpct.text = "Fg"
    }
    
    func configureStats(forStats: PlayerStats) {
        season.text = String(forStats.season) + "-" + String(forStats.season+1)
        pts.text = String(round(forStats.pts * 10) / 10.0)
        rebs.text = String(round(forStats.reb * 10) / 10.0)
        ast.text = String(round(forStats.ast * 10) / 10.0)
        stls.text = String(round(forStats.stl * 10) / 10.0)
        blks.text = String(round(forStats.blk * 10) / 10.0)
        fgpct.text = String(Int(round(forStats.fg_pct * 100)))
        threepct.text = String(Int(round(forStats.fg3_pct * 100)))
        ft_pct.text = String(Int(round(forStats.ft_pct * 100)))
    }

}
