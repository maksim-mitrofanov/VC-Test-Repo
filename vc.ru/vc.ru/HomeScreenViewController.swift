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
    
    // Animations
    private var placeholderView: LoadingPlaceholderView? = nil
    
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
        tableView.register(VCTableViewCell.self, forCellReuseIdentifier: VCTableViewCell.id)
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
        placeholderView = LoadingPlaceholderView()
        placeholderView?.cover(mainTableView)
        mainTableView.isUserInteractionEnabled = false
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
