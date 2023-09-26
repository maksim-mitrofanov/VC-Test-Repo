//
//  NewsFeedDataModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.09.2023.
//

import Foundation

struct Welcome: Codable {
    let result: Result
    let message: String
}

extension Welcome {
    struct Result: Codable {
        let news: [News]
        let lastID: Int?
    }
    
    struct News: Codable {
        let id: Int?
        let subsite: Subsite?
        let title: String?
        let date: Int?
        let blocks: [Block]?
        let counters: NewsCounters?
    }
    
    struct Subsite: Codable {
        let name: String?
        let avatar: Avatar?
    }
    
    struct Avatar: Codable {
        let type: String?
        let data: AvatarData?
    }
    
    struct AvatarData: Codable {
        let uuid: String?
    }
    
    struct Block: Codable {
        let type: String?
        let data: BlockData?
    }
    
    struct BlockData: Codable {
        let text: String?
    }
    
    struct NewsCounters: Codable {
        let comments: Int?
        let reposts: Int?
    }
}
