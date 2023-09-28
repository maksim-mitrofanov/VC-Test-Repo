//
//  VCTableViewCell.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import UIKit
import Foundation

class VCTableViewCell: UITableViewCell {
    static let id = "VCTableViewCell"
    
    let subsiteNameLabel = UILabel()
    let publishedTimeLabel = UILabel()
    let subsiteImage = UIView()
    let titleLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubsiteImage()
        setupSubsiteNameLabel()
        setupPublishedTimeLabel()
        contentView.backgroundColor = .purple.withAlphaComponent(0.1)
    }
    
    func setup(from model: VCCellModel) {
        subsiteNameLabel.text = model.subsiteName
        publishedTimeLabel.text = model.timeSincePublished
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension VCTableViewCell {
    func setupSubsiteNameLabel() {
        subsiteNameLabel.textColor = .black
        subsiteNameLabel.numberOfLines = 0
        subsiteNameLabel.font = UIFont(name: "Roboto-Medium", size: 15)

        
        contentView.addSubview(subsiteNameLabel)
        
        subsiteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subsiteNameLabel.leadingAnchor.constraint(equalTo: subsiteImage.trailingAnchor, constant: 8),
            subsiteNameLabel.centerYAnchor.constraint(equalTo: subsiteImage.centerYAnchor),
            subsiteNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func setupSubsiteImage() {
        subsiteImage.backgroundColor = .white
        subsiteImage.layer.cornerRadius = 8
        
        contentView.addSubview(subsiteImage)
        
        subsiteImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subsiteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subsiteImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            subsiteImage.widthAnchor.constraint(equalToConstant: 22),
            subsiteImage.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func setupPublishedTimeLabel() {
        publishedTimeLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        publishedTimeLabel.textColor = .darkGray
        
        contentView.addSubview(publishedTimeLabel)
        
        publishedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            publishedTimeLabel.leadingAnchor.constraint(equalTo: subsiteNameLabel.trailingAnchor, constant: 12),
            publishedTimeLabel.centerYAnchor.constraint(equalTo: subsiteNameLabel.centerYAnchor)
        ])
    }
}

#Preview {
    ViewController()
}
