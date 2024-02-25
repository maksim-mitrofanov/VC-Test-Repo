//
//  VCCellModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import Foundation

struct VCRealCellModel: VCCellModel {
    let subsiteImageData: Data?
    let subsiteName: String
    let articleImageData: Data?
    let articleImageType: String
    let timeSincePublished: String
    let title: String
    let bodyText: String
    let commentsCount: Int
    let repostsCount: Int
    let votes: Int
    let id: Int
}

struct VCEmptyCellModel: VCCellModel {
    let subsiteImageData: Data? = nil
    let subsiteName: String = "Placeholder"
    let articleImageData: Data? = nil
    let articleImageType: String = "Placeholder"
    let timeSincePublished: String = "Placeholder"
    let title: String = "Placeholder"
    let bodyText: String = "Placeholder"
    let commentsCount: Int = 0
    let repostsCount: Int = 0
    let votes: Int = 0
    let id: Int = 0
}

protocol VCCellModel: Identifiable {
    var subsiteImageData: Data? { get }
    var subsiteName: String { get }
    var articleImageData: Data? { get }
    var articleImageType: String { get }
    var timeSincePublished: String { get }
    var title: String { get }
    var bodyText: String { get }
    var commentsCount: Int { get }
    var repostsCount: Int { get }
    var votes: Int { get }
    var id: Int { get }
}
