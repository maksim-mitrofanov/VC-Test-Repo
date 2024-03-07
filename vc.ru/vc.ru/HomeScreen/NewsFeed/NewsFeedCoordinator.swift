//
//  NewsFeedCoordinator.swift
//  vc.ru
//
//  Created by  Maksim on 29.02.24.
//

import UIKit

final class NewsFeedCoordinator: UIViewController, INewsFeedViewCoordinator {
    
    private var presentedNews = [NewsBlockModel]()
    weak var presentedTableView: UITableView?
    
    init(tableView: UITableView, setupWithEmptyState: Bool) {
        self.presentedTableView = tableView
        self.tableViewDataSource = TableViewDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let presentedCell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.id, for: indexPath) as? VCTableViewCell
            else { fatalError() }
                        
            presentedCell.setup(from: itemIdentifier)
            presentedCell.selectionStyle = .none
            
            return presentedCell
        })
        
        super.init(nibName: nil, bundle: nil)
        if setupWithEmptyState { setupEmptyState() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(news: [NewsBlockModel]) {
        presentedNews = news
        if isCovered { uncoverTableView() }
        
        var snapshot = TableViewDataSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(news, toSection: .main)
        tableViewDataSource.apply(snapshot)
    }
    
    // MARK: - DiffableDataSource
    private let tableViewDataSource: TableViewDataSource
    
    typealias TableViewDataSource = UITableViewDiffableDataSource<Section, NewsBlockModel>
    typealias TableViewDataSnapshot = NSDiffableDataSourceSnapshot<Section, NewsBlockModel>
    
    enum Section {
        case main
    }
      
    
    // MARK: - Placeholder view
    private var placeholderView: LoadingPlaceholderView? = nil
    private var isCovered: Bool { placeholderView != nil }

    private func coverTableView() {
        if let presentedTableView {
            placeholderView = LoadingPlaceholderView()
            placeholderView?.cover(presentedTableView)
            presentedTableView.isUserInteractionEnabled = false
        }
    }
    
    private func uncoverTableView() {
        placeholderView?.uncover(animated: true)
        presentedTableView?.isUserInteractionEnabled = true
    }
    
    private func setupEmptyState() {
        presentedNews = [.empty, .empty]
        coverTableView()
    }
    
    // MARK: - Table View Delegate, Data Source, Prefetch
    var onPrefetchRequest: (() -> Void)? = nil
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        onPrefetchRequest?()
    }
}
