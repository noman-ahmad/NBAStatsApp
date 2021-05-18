//
//  GameStats.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/13/21.
//

import Foundation

struct GameStatsData : Decodable {
    let data: [GameStats]
    let meta: DataMeta
}

struct GameStats : Decodable {
    let id: Int?
    let ast: Int?
    let blk: Int?
    let dreb: Int?
    let fg3_pct: Float?
    let fg3a: Int?
    let fg3m: Int?
    let fg_pct: Float?
    let fga: Int?
    let fgm: Int?
    let ft_pct: Float?
    let fta: Int?
    let ftm: Int?
    let game: GameInfo?
    let min: String?
    let oreb: Int?
    let pf: Int?
    let player: PlayerInfo?
    let pts: Int?
    let reb: Int?
    let stl: Int?
    let team: TeamInfo?
    
    static func <(lhs: GameStats, rhs: GameStats) -> Bool {
        
        if lhs.min == "0" && rhs.min == "0" {
            return true
        } else if lhs.min == "0" {
            return true
        } else if (lhs.min == "" && rhs.min == "") {
            return false
        } else if (lhs.min == "") {
            return true
        } else if (rhs.min == "") {
            return false
        }
        let v1 = lhs.min![lhs.min!.index(lhs.min!.startIndex, offsetBy: 0)]
        let v2 = lhs.min![lhs.min!.index(lhs.min!.startIndex, offsetBy: 1)]
        
        let x1 = rhs.min![rhs.min!.index(rhs.min!.startIndex, offsetBy: 0)]
        let x2 = rhs.min![rhs.min!.index(rhs.min!.startIndex, offsetBy: 1)]
        
        if (x2 == ":") && (v2 == ":") {
            return v1 < x1
        } else if (v2 == ":") {
            return true
        } else if (x2 == ":") {
            return false
        } else if (x1 == v1){
            return v2 < x2
        } else {
            return v1 < x1
        }
    }
}

