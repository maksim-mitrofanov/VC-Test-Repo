//
//  VCCellModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import Foundation

struct VCCellModel: Equatable, Hashable {
    let subsiteImageData: Data?
    let subsiteName: String
    let articleImageData: Data?
    let articleImageType: String
    let timeSincePublished: String
    let title: String
    let bodyText: String
    let commentsCount: Int?
    let repostsCount: Int?
    let votes: Int?
    let id: Int
}

extension VCCellModel {
    static let empty = VCCellModel(
        subsiteImageData: nil,
        subsiteName: "Placeholder",
        articleImageData: nil,
        articleImageType: "Placeholder",
        timeSincePublished: "Placeholder",
        title: "Placeholder",
        bodyText: "Placeholder",
        commentsCount: nil,
        repostsCount: nil,
        votes: nil,
        id: 0
    )
}
