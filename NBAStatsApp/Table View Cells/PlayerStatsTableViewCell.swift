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
    @IBOutlet weak var gamesPlayed: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureInitial() {
        season.text = "Season"
        pts.text = "PPG"
        ast.text = "APG"
        rebs.text = "RPG"
        stls.text = "SPG"
        blks.text = "BPG"
        ft_pct.text = "FT%"
        threepct.text = "3P%"
        fgpct.text = "FG%"
        gamesPlayed.text = "GP"
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
        gamesPlayed.text = String(forStats.games_played)
    }
    
    func configureAverges(forStats: [PlayerStats]) {
        var points_average = 0.0
        var rebounds_average = 0.0
        var assists_average = 0.0
        var blks_average = 0.0
        var stls_average = 0.0
        var fts_average = 0.0
        var fg_average = 0.0
        var three_average = 0.0
        var games_average = 0.0
        
        for stats in forStats {
            points_average += Double(stats.pts)
            rebounds_average += Double(stats.reb)
            assists_average += Double(stats.ast)
            blks_average += Double(stats.blk)
            stls_average += Double(stats.stl)
            three_average += Double(stats.fg3_pct)
            fts_average += Double(stats.ft_pct)
            games_average += Double(stats.games_played)
            fg_average += Double(stats.fg_pct)
        }
        
        let career_points = (points_average / Double(forStats.count))
        let career_rebs = (rebounds_average / Double(forStats.count))
        let career_ast = (assists_average / Double(forStats.count))
        let career_blks = (blks_average / Double(forStats.count))
        let career_stls = (stls_average / Double(forStats.count))
        let career_fts = (fts_average / Double(forStats.count))
        let career_three = (three_average / Double(forStats.count))
        let career_gms = (games_average / Double(forStats.count))
        let career_fg = (fg_average) / Double(forStats.count)

        season.text = "Career"
        pts.text = String(round(career_points * 10) / 10.0)
        rebs.text = String(round(career_rebs * 10) / 10.0)
        ast.text = String(round(career_ast * 10) / 10.0)
        stls.text = String(round(career_stls * 10) / 10.0)
        blks.text = String(round(career_blks * 10) / 10.0)
        fgpct.text = String(Int(round(career_fg * 100)))
        threepct.text = String(Int(round(career_three * 100)))
        ft_pct.text = String(Int(round(career_fts * 100)))
        gamesPlayed.text = String(Int(career_gms))
    }
}
