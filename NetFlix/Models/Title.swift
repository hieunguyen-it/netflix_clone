//
//  Movie.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 4/19/23.
//

import Foundation


struct TrendingTitleReponse: Codable{
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let over_view: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let title: String?
    let overview: String?
}
