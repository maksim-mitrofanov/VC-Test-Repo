//
//  HomeScreenViewController.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import UIKit

final class HomeScreenViewController: UIViewController {
    // Must be an injected properties
    let presenter = NewsPresenter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()
        presenter.delegate = self
        presenter.fetchLatestNews()
    }
    
    lazy private var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VCTableViewCell.self, forCellReuseIdentifier: VCTableViewCell.id)
        tableView.accessibilityIdentifier = GlobalNameSpace.vcHomeScreenTableView.rawValue
        return tableView
    }()
    
    lazy private var imagePreviewTransitionDelegate: ImagePreviewTransitionDelegate = {
        let transitionDelegate = ImagePreviewTransitionDelegate()
        return transitionDelegate
    }()
    
    @objc private func fetchData() {
        presenter.fetchLatestNews()
    }
    
    func presentImagePreviewController(withImage imageData: Data?, fromFrame frame: CGRect) {
        let previewController = ImagePreviewViewController()
        previewController.setImageData(to: imageData)
        previewController.modalPresentationStyle = .custom
        
        let transitionDelegate = ImagePreviewTransitionDelegate()
        transitionDelegate.originFrame = frame
        previewController.transitioningDelegate = transitionDelegate
        
        present(previewController, animated: true, completion: nil)
    }
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
        presentedCell.imageWasTapped = { [weak self] in
            if let cell = tableView.cellForRow(at: indexPath) as? VCTableViewCell {
                let originFrame = tableView.convert(cell.articleImageView.frame, to: nil)
                self?.presentImagePreviewController(withImage: cell.dataModel?.articleImageData, fromFrame: originFrame)
            }
        }
        
        return presentedCell
    }
}

// NewsPresenterDelegate
extension HomeScreenViewController: NewsPresenterDelegate {
    func newsWereUpdated() {
        mainTableView.reloadData()
    }
}
