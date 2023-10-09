//
//  NewsFeedDataModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.09.2023.
//

import Foundation

struct ServerFeedback: Decodable {
    let result: Result
    let message: String
}

extension ServerFeedback {
    struct Result: Decodable {
        let news: [NewsEntry]
        let lastId: Int
    }
    
    struct NewsEntry: Decodable {
        let id: Int
        let author: Subsite
        let subsite: Subsite
        let title: String
        let date: Int
        let blocks: [NewsBlock]
        let counters: NewsCounters
        let likes: Likes
    }
    
    struct Likes: Decodable {
        let summ: Int
    }
    
    struct Subsite: Decodable {
        let id: Int
        let name: String
        let avatar: Avatar
    }
    
    struct Avatar: Decodable {
        let type: String
        let data: AvatarData
    }
    
    struct AvatarData: Decodable {
        let uuid: String
    }
    
    struct NewsCounters: Decodable {
        let comments: Int
        let reposts: Int
    }
    
    enum NewsBlock {
        case text(TextBlock)
        case media(MediaBlock)
        case other
    }
    
    struct TextBlock: Decodable {
        let data: TextBlockData
    }
    
    struct TextBlockData: Decodable {
        let text: String
    }
    
    struct MediaBlock: Decodable {
        let data: MediaBlockData
    }
    
    struct MediaBlockData: Decodable {
        let items: [MediaBlockItem]
    }
    
    struct MediaBlockItem: Decodable {
        let image: MediaBlockImage
    }
    
    struct MediaBlockImage: Decodable {
        let data: MediaBlockImageData
    }
    
    struct MediaBlockImageData: Decodable {
        let uuid: String
    }
}

extension ServerFeedback.NewsBlock : Decodable {
    struct InvalidTypeError: Error {
        var type: String
    }
    
    private enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
                
        switch type {
        case "media":
            self = .media(try ServerFeedback.MediaBlock(from: decoder))
        case "text":
            self = .text(try ServerFeedback.TextBlock(from: decoder))
        default:
            self = .other
        }
    }
}

extension ServerFeedback.NewsEntry {
    func getArticleImageUUID() -> String {
        var result = ""
        
        let firstMediaBlock = blocks.first { block in
            if case .media(_) = block {
                return true
            } else {
                return false
            }
        }
        
        if let mediaBlock = firstMediaBlock {
            switch mediaBlock {
            case .media(let media):
                result = media.data.items[0].image.data.uuid
            default:
                break
            }
        }
        
        return result
    }
    
    func getArticleSubtitle() -> String {
        var result = ""

        let firstTextBlock = blocks.first { block in
            if case .text(_) = block {
                return true
            } else {
                return false
            }
        }
        
        if let textBlock = firstTextBlock {
            switch textBlock {
            case .text(let textData):
                result = textData.data.text
            default:
                break
            }
        }
        
        return result
    }
}
