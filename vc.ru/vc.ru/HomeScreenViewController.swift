//
//  HomeScreenViewController.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import UIKit

final class HomeScreenViewController: UIViewController {
    let presenter = NewsPresenter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()
        coverMainTableView()
        presenter.delegate = self
        presenter.fetchLatestNews()
    }
    
    private var placeholderView: LoadingPlaceholderView? = nil
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = GlobalNameSpace.vcHomeScreenTableView.rawValue
        tableView.register(VCTableViewCell.self, forCellReuseIdentifier: VCTableViewCell.id)
        return tableView
    }()
}

// MARK: - Table View
extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTableViewLayout() {
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
    
    private func coverMainTableView() {
        placeholderView = LoadingPlaceholderView()
        placeholderView?.cover(mainTableView)
        mainTableView.isUserInteractionEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presentedCell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.id, for: indexPath) as? VCTableViewCell
        else { fatalError() }
        
        let cellIndex = indexPath.section + indexPath.row
        let model = presenter.getCell(at: cellIndex)
        
        presentedCell.setup(from: model)
        presentedCell.selectionStyle = .none
        
        return presentedCell
    }
}

// NewsPresenterDelegate
extension HomeScreenViewController: NewsPresenterDelegate {
    func newsWereUpdated() {
        placeholderView?.uncover(animated: true)
        mainTableView.isUserInteractionEnabled = true
        mainTableView.reloadData()
    }
}
