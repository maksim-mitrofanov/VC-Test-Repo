//
//  ViewController.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let presenter = NewsPresenter()
    let mainTableView = UITableView()
    let activityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
//        setupActivityIndicator()
        presenter.delegate = self
        presenter.fetchLatestNews()
    }
    
    @objc private func fetchData() {
        presenter.fetchLatestNews()
    }
}

// MARK: - Layout
extension ViewController {
    private func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        mainTableView.accessibilityIdentifier = GlobalNameSpace.homeScreenTableView.rawValue
        view.addSubview(mainTableView)
        setupTableViewLayout()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(VCTableViewCell.self, forCellReuseIdentifier: VCTableViewCell.id)
    }
    
    private func setupTableViewLayout() {
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.id, for: indexPath) as? VCTableViewCell
        else { fatalError() }
        
        let cellIndex = indexPath.section + indexPath.row
        let model = presenter.getCell(at: cellIndex)
        
        cell.setup(from: model)
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: NewsPresenterDelegate {
    func newsWereUpdated() {
        activityIndicatorView.stopAnimating()
        mainTableView.reloadData()
    }
}

#Preview {
    ViewController()
}
