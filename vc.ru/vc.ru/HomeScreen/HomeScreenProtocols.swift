//
//  HomeScreenController.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import Foundation

protocol HomeScreenController: AnyObject {
    func display(news: [VCCellModel])
}

protocol NewsPresenter: AnyObject {
    func fetchNews()
}

