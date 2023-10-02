//
//  NewsPresenter.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 02.10.2023.
//

import Foundation

class NewsPresenter {
    private(set) var presentedNews = [VCCellModel]()
    var delegate: NewsPresenterDelegate?
    
    func fetchLatestNews() {
        let networkService = NetworkService.shared
        networkService.completion = { [weak self] news in
            self?.presentedNews = news?.toVCCellModels() ?? []
            
            DispatchQueue.main.async {
                self?.delegate?.newsWereUpdated()
            }
        }
        networkService.fetchContent()
    }
}

protocol NewsPresenterDelegate {
    func newsWereUpdated()
}
