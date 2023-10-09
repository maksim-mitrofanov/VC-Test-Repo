//
//  VCCellModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import Foundation

struct VCCellModel: Identifiable {
    let subsiteImageData: Data?
    let subsiteName: String
    let articleImageData: Data?
    let timeSincePublished: String
    let title: String
    let bodyText: String
    let commentsCount: Int
    let repostsCount: Int
    let votes: Int
    let id: Int
}
