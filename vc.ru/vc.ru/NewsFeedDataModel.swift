//
//  NewsFeedDataModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.09.2023.
//

import UIKit
import Foundation

struct Welcome: Codable {
    let result: Result
    let message: String
}

extension Welcome {
    func toVCCellModels() -> [VCCellModel] {
        let dummyImageData = UIImage(named: "demo_image")!.jpegData(compressionQuality: 1)!

        return result.news.map { newsModel in
            VCCellModel(
                subsiteImageData: nil,
                subsiteName: newsModel.subsite?.name ?? "Error",
                timeSincePublished: newsModel.date?.description ?? "Error",
                title: newsModel.title ?? "Error",
                bodyText: newsModel.blocks?[0].data?.text ?? "Error",
                mainImageData: dummyImageData,
                commentsCount: newsModel.counters?.comments ?? 0,
                repostsCount: newsModel.counters?.reposts ?? 0,
                votes: 0
            )
        }
    }
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
