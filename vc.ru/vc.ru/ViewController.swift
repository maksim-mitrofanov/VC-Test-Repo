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
    let imagePreviewTransitionDelegate = ImagePreviewTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        mainTableView.accessibilityIdentifier = GlobalNameSpace.vcHomeScreenTableView.rawValue
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

extension ViewController {
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

extension ViewController: NewsPresenterDelegate {
    func newsWereUpdated() {
        mainTableView.reloadData()
    }
}
