//
//  NewsFeedPresenter.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 02.10.2023.
//

import UIKit

final class HomeScreenPresenter: IHomeScreenPresenter {
    private var presentedNews = [NewsBlockModel]()
    weak var viewInput: IHomeScreenView?
    private var interactor: IHomeScreenInteractor
    
    init(interactor: IHomeScreenInteractor) {
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
