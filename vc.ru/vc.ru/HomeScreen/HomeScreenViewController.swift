//
//  HomeScreenViewController.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import UIKit

final class HomeScreenViewController: UIViewController {
    private let presenter: HomeScreenPresenter
    private var tableViewCoordinator: NewsFeedTableCoordinator?
    
    fileprivate init(presenter: HomeScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter.loadMoreData()
    }
        
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = GlobalNameSpace.vcHomeScreenTableView.rawValue
        tableView.register(VCTableViewCell.self, forCellReuseIdentifier: VCTableViewCell.id)
        return tableView
    }()
}

extension HomeScreenViewController: HomeScreenViewInput {
    func display(news: [VCCellModel]) {
        tableViewCoordinator?.setup(with: news)
    }
}

// MARK: - Table View
extension HomeScreenViewController {
    private func setupTableView() {
        tableViewCoordinator = NewsFeedTableViewCoordinator(tableView: mainTableView, setupWithEmptyState: true)
        tableViewCoordinator?.onPrefetchRequest = { [weak self] in self?.presenter.loadMoreData() }
        mainTableView.delegate = tableViewCoordinator
        mainTableView.dataSource = tableViewCoordinator
        mainTableView.prefetchDataSource = tableViewCoordinator
        
        view.addSubview(mainTableView)
        mainTableView.separatorStyle = .none
        mainTableView.backgroundColor = UIColor.clear
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

final class HomeScreenAssembly {
    func assemble(with networkService: NetworkService) -> UIViewController {
        let presenter = NewsFeedPresenter(networkService: networkService)
        let viewController = HomeScreenViewController(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }
}
