//
//  HomeScreenViewInput.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import UIKit
import Foundation

protocol HomeScreenViewInput: AnyObject {
    func display(news: [VCCellModel])
}

protocol HomeScreenPresenter: AnyObject {
    func loadMoreData()
}

protocol NewsFeedTableCoordinator: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func setup(with: [VCCellModel])
    var onPrefetchRequest: (() -> Void)? { get set }
}
