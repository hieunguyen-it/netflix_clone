//
//  YoutubeSearchResponse.swift
//  NetFlix
//
//  Created by Nguyen Phan Hieu on 5/11/23.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
