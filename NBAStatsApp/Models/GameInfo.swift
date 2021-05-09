//
//  GameInfo.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/26/21.
//

import Foundation


struct GameData: Decodable{
    let data: [GameInfo]
    let meta: DataMeta
}

struct GameInfo: Decodable {
    let id: Int
    let home_team_score: Int
    let visitor_team_score: Int
    let date: String
    let season: Int
    let home_team: TeamInfo
    let visitor_team: TeamInfo
}
