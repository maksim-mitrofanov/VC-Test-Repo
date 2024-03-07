//
//  IHomeScreenView.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import UIKit

protocol IHomeScreenView: AnyObject {
    func display(news: [NewsBlockModel])
}

protocol IHomeScreenPresenter: AnyObject {
    func loadMoreNews()
}

protocol IHomeScreenInteractor: AnyObject {
    func loadMoreNews(completion: @escaping (([NewsBlockModel]) -> Void))
}

protocol IHomeScreenNetworkService: AnyObject {
    func fetchNews(lastID: Int?, completion: @escaping ((ServerFeedback?) -> Void))
    func fetchAsset(uuid: String, completion: @escaping ((Data?) -> Void))
}

protocol INewsFeedViewCoordinator: UITableViewDataSourcePrefetching {
    func present(news: [NewsBlockModel])
    var onPrefetchRequest: (() -> Void)? { get set }
}
