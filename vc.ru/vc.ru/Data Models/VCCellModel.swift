//
//  VCCellModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import UIKit
import Foundation

struct VCCellModel: Identifiable {
    let subsiteImageUUID: String
    let subsiteName: String
    let timeSincePublished: String
    let title: String
    let bodyText: String
    let mainImageUUID: String
    let commentsCount: Int
    let repostsCount: Int
    let votes: Int
    let id: Int
}
