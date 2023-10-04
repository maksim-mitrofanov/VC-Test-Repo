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
    let fetchDataButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupTableView()
        presenter.delegate = self
        presenter.fetchLatestNews()
    }
    
    @objc private func fetchData() {
        presenter.fetchLatestNews()
    }
}

// MARK: - Layout
extension ViewController {
    private func setupTableView() {
        view.addSubview(mainTableView)
        setupTableViewLayout()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(VCTableViewCell.self, forCellReuseIdentifier: VCTableViewCell.id)
    }
    
    private func setupButton() {
        view.addSubview(fetchDataButton)
        setupFetchButtonLayout()
        fetchDataButton.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
    }
    
    private func setupTableViewLayout() {
        let safeArea = view.safeAreaLayoutGuide
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            mainTableView.topAnchor.constraint(equalTo: safeArea.topAnchor,         constant: 10),
            mainTableView.bottomAnchor.constraint(equalTo: fetchDataButton.topAnchor, constant: -20)
        ])
    }
    
    private func setupFetchButtonLayout() {
        let borderColor = UIColor(red: 109 / 255, green: 190 / 255, blue: 90 / 255, alpha: 1)
        fetchDataButton.layer.cornerRadius = 25
        fetchDataButton.layer.borderWidth = 1.5
        fetchDataButton.layer.borderColor = borderColor.cgColor
        
        fetchDataButton.setTitle("Fetch news", for: .normal)
        fetchDataButton.setTitleColor(.black, for: .normal)
        fetchDataButton.setTitleColor(.black.withAlphaComponent(0.2), for: .highlighted)
        
        // Constraints
        let safeArea = view.safeAreaLayoutGuide
        fetchDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fetchDataButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            fetchDataButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            fetchDataButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            fetchDataButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ViewController: UITableViewDataSource , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.presentedNews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.id, for: indexPath) as? VCTableViewCell
        else { fatalError() }
        
        cell.setup(from: presenter.presentedNews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 200, height: 16)
            view.backgroundColor = .lightGray.withAlphaComponent(0.2)
            
            return view
        }
        
        return nil
    }
}

extension ViewController: NewsPresenterDelegate {
    func newsWereUpdated() {
        mainTableView.reloadData()
    }
}

#Preview {
    ViewController()
}
