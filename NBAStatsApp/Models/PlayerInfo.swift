//
//  PlayerInfo.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/30/21.
//

import Foundation

struct PlayerData: Decodable{
    let data: [PlayerInfo]
    let meta: DataMeta
}

struct PlayerInfo: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let position: String?
    let height_feet: Int?
    let height_inches: Int?
    let weight_pounds: Int?
    let team: TeamInfo?
}


