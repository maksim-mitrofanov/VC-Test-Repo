//
//  NewsFeedPresenter.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 02.10.2023.
//

import UIKit

final class HomeScreenPresenter: HomeScreenViewPresenter {
    private var presentedNews = [NewsBlockModel]()
    weak var viewInput: HomeScreenViewInput?
    private var interactor: HomeScreenViewInteractor
    
    init(interactor: HomeScreenViewInteractor) {
        self.interactor = interactor
    }
    
    func loadMoreNews() {
        interactor.loadMoreNews(completion: { [weak self] data in
            self?.addToPresented(news: data)
        })
    }
    
    private func addToPresented(news: [NewsBlockModel]) {
        presentedNews.append(contentsOf: news)
        
        DispatchQueue.main.async { [weak self] in
            if let presentedNews = self?.presentedNews {
                self?.viewInput?.display(news: presentedNews)
            }
        }
    }
}
