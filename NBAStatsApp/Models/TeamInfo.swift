//
//  TeamInfo.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 4/26/21.
//

import Foundation

struct TeamData: Decodable{
    let data: [TeamInfo]
    let meta: DataMeta
}

struct TeamInfo: Decodable {
    let id: Int
    let abbreviation: String
    let city: String
    let conference: String
    let division: String
    let full_name: String
    let name: String
}

struct DataMeta: Decodable{
    let total_pages: Int
    let current_page: Int
    let per_page: Int
    let total_count: Int
}

