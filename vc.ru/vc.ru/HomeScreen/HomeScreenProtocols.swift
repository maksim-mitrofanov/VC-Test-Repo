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

protocol HomeScreenInteractor: AnyObject {
    func loadMoreNews(lastElementID: Int?, completion: @escaping (([NewsBlockModel]) -> Void))
}

protocol HomeScreenNetworkService: AnyObject {
    func fetchNews(lastID: Int?, completion: @escaping ((ServerFeedback?) -> Void))
    func fetchAsset(uuid: String, completion: @escaping ((Data?) -> Void))
}

protocol NewsFeedTableViewCoordinator: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func present(news: [NewsBlockModel])
    var onPrefetchRequest: (() -> Void)? { get set }
}
