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
    
    //Properties
    private let accessibilityIdentifier = GlobalNameSpace.vcHomeScreenTableView.rawValue
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        loadAndShowData()
    }
    
    lazy private var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = accessibilityIdentifier
        tableView.register(VCTableViewCellEager.self, forCellReuseIdentifier: VCTableViewCellEager.id)
        return tableView
    }()
    
    lazy private var imagePreviewTransitionDelegate: ImagePreviewTransitionDelegate = {
        let transitionDelegate = ImagePreviewTransitionDelegate()
        return transitionDelegate
    }()
    
    func presentImagePreviewController(withImage imageData: Data?, fromFrame frame: CGRect) {
        let previewController = ImagePreviewViewController()
        previewController.setImageData(to: imageData)
        previewController.modalPresentationStyle = .custom
        
        let transitionDelegate = ImagePreviewTransitionDelegate()
        transitionDelegate.originFrame = frame
        previewController.transitioningDelegate = transitionDelegate
        
        present(previewController, animated: true, completion: nil)
    }
    
    func loadAndShowData() {
        setupTableViewLayout()
        presenter.fetchLatestNews()
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
        guard let presentedCell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCellEager.id, for: indexPath) as? VCTableViewCellEager
        else { fatalError() }
        
        let cellIndex = indexPath.section + indexPath.row
        let model = presenter.getCell(at: cellIndex)
        
        presentedCell.setup(from: model)
        presentedCell.selectionStyle = .none
        presentedCell.imageWasTapped = { }
        
        return presentedCell
    }
}

// NewsPresenterDelegate
extension HomeScreenViewController: NewsPresenterDelegate {
    func newsWereUpdated() {
        mainTableView.reloadData()
    }
}
