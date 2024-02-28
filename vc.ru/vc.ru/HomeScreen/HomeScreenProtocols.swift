//
//  HomeScreenViewProtocol.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import Foundation

protocol HomeScreenViewProtocol: AnyObject {
    func display(news: [VCCellModel])
}

protocol HomeScreenPresenterProtocol: AnyObject {
    func fetchNews()
    func 
}

