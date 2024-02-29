//
//  NewsFeedTableViewCoordinator.swift
//  vc.ru
//
//  Created by  Maksim on 29.02.24.
//

import UIKit

final class NewsFeedTableViewCoordinator: UIViewController, NewsFeedTableCoordinator {
    
    private var presentedNews = [VCCellModel]()
    
    init(tableView: UITableView, setupWithEmptyState: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.tableView = tableView
        presentedNews = [.empty, .empty]
        coverTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with news: [VCCellModel]) {
        presentedNews = news
        if isCovered { uncoverTableView() }
        tableView?.reloadData()
    }
    
    
    // MARK: - Placeholder view
    private var placeholderView: LoadingPlaceholderView? = nil
    private var isCovered: Bool { placeholderView != nil }

    private func coverTableView() {
        if let tableView {
            placeholderView = LoadingPlaceholderView()
            placeholderView?.cover(tableView)
            tableView.isUserInteractionEnabled = false
        }
    }
    
    private func uncoverTableView() {
        placeholderView?.uncover(animated: true)
        tableView?.isUserInteractionEnabled = true
    }
    
    // MARK: - Table View Delegate, Data Source, Prefetch
    weak var tableView: UITableView?
    var onPrefetchRequest: (() -> Void)? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presentedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presentedCell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.id, for: indexPath) as? VCTableViewCell
        else { fatalError() }
        
        let cellIndex = indexPath.section + indexPath.row
        let model = presentedNews[cellIndex]
        
        presentedCell.setup(from: model)
        presentedCell.selectionStyle = .none
        
        return presentedCell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        onPrefetchRequest?()
    }
}
