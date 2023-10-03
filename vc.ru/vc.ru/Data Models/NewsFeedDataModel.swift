//
//  NewsFeedDataModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.09.2023.
//

import Foundation

struct ServerFeedback: Codable {
    let result: Result
    let message: String
}

extension ServerFeedback {
    struct Result: Codable {
        let news: [NewsBlock]
        let lastId: Int
    }
    
    struct NewsBlock: Codable {
        let id: Int
        let author: Subsite
        let subsite: Subsite
        let title: String
        let date: Int
        let counters: NewsCounters
    }
    
    struct Subsite: Codable {
        let name: String
        let avatar: Avatar
    }
    
    struct Avatar: Codable {
        let type: String
        let data: AvatarData
    }
    
    struct AvatarData: Codable {
        let uuid: String
    }
    
    struct NewsCounters: Codable {
        let comments: Int
        let reposts: Int
    }
}
