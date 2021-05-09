//
//  PlayerStatsInfo.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/30/21.
//

import Foundation

struct StatsData: Decodable {
    let data: [PlayerStats]
}

struct PlayerStats: Decodable {
    let games_played: Int
    let player_id: Int
    let season: Int
    let min: String
    let fgm: Float
    let fga: Float
    let fg3m: Float
    let fg3a: Float
    let ftm: Float
    let fta: Float
    let oreb: Float
    let dreb: Float
    let reb: Float
    let ast: Float
    let stl: Float
    let blk: Float
    let turnover: Float
    let pf: Float
    let pts: Float
    let fg_pct: Float
    let fg3_pct: Float
    let ft_pct: Float
}
