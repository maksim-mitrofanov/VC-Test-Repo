//
//  HomeScreenInput.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import Foundation

protocol HomeScreenInput: AnyObject {
    func display(news: [VCCellModel])
    var getNews: (() -> Void)? { get set }
}
