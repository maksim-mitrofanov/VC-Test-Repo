//
//  HomeScreenViewInput.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import UIKit

protocol HomeScreenViewInput: AnyObject {
    func display(news: [NewsBlockModel])
}

protocol HomeScreenViewPresenter: AnyObject {
    func loadMoreNews()
}

protocol NewsFeedNetworkService: AnyObject {
    func fetchNews(lastID: Int?, completion: @escaping ((ServerFeedback?) -> Void))
    func fetchAsset(uuid: String, completion: @escaping ((Data?) -> Void))
}

protocol NewsFeedViewCoordinator: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func present(news: [NewsBlockModel])
    var onPrefetchRequest: (() -> Void)? { get set }
}
