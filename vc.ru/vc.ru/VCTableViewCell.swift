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
    let bodyLabel = UILabel()
    var articleImage = UIImageView()
    let showMoreOptionsImage = UIImage(systemName: "ellipsis")
    let showMoreOptionsButton = UIButton(type: .system)
    let commentsCountImage = UIImage(systemName: "bubble.right")
    let commentsCountButton = UIButton(type: .system)
    let commentsCountLabel = UILabel()
    let repostsCountImage = UIImage(systemName: "arrow.up.arrow.down.circle")
    let repostsCountButton = UIButton(type: .system)
    let repostsCountLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubsiteImage()
        setupSubsiteNameLabel()
        setupPublishedTimeLabel()
        setupShowMoreOptionsButton()
        setupTitleLabel()
        setupBodyLabel()
        setupArticleImage()
        setupCommentsCountButton()
        setupCommentsCountLabel()
        setupRepostsCountButton()
        setupRepostsCountLabel()
        contentView.backgroundColor = .purple.withAlphaComponent(0.1)
    }
    
    func setup(from model: VCCellModel) {
        subsiteNameLabel.text = model.subsiteName
        publishedTimeLabel.text = model.timeSincePublished
        titleLabel.text = model.title
        bodyLabel.text = model.bodyText
        articleImage.image = UIImage(data: model.mainImageData)
        commentsCountLabel.text = model.commentsCount.description
        repostsCountLabel.text = model.repostsCount.description
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
            subsiteNameLabel.centerYAnchor.constraint(equalTo: subsiteImage.centerYAnchor)
        ])
    }
    
    func setupSubsiteImage() {
        subsiteImage.backgroundColor = .white
        subsiteImage.layer.cornerRadius = 8
        
        contentView.addSubview(subsiteImage)
        
        subsiteImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subsiteImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subsiteImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
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
    
    func setupShowMoreOptionsButton() {
        showMoreOptionsButton.setImage(showMoreOptionsImage, for: .normal)
        showMoreOptionsButton.tintColor = .systemGray
        
        contentView.addSubview(showMoreOptionsButton)
        
        showMoreOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showMoreOptionsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            showMoreOptionsButton.centerYAnchor.constraint(equalTo: subsiteNameLabel.centerYAnchor)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 22)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: subsiteNameLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupBodyLabel() {
        bodyLabel.font = UIFont(name: "Roboto-Regular", size: 17)
        bodyLabel.textColor = .black
        bodyLabel.numberOfLines = 0
        
        contentView.addSubview(bodyLabel)
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    func setupArticleImage() {
        articleImage.backgroundColor = .black
        
        contentView.addSubview(articleImage)
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleImage.heightAnchor.constraint(equalToConstant: 210),
            articleImage.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            articleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupCommentsCountButton() {
        commentsCountButton.setImage(commentsCountImage, for: .normal)
        commentsCountButton.tintColor = .systemGray
        
        contentView.addSubview(commentsCountButton)
        
        commentsCountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentsCountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentsCountButton.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: 16),
            commentsCountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupCommentsCountLabel() {
        commentsCountLabel.textColor = .systemGray
        commentsCountLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        
        contentView.addSubview(commentsCountLabel)
        
        commentsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentsCountLabel.leadingAnchor.constraint(equalTo: commentsCountButton.trailingAnchor, constant: 4),
            commentsCountLabel.centerYAnchor.constraint(equalTo: commentsCountButton.centerYAnchor)
        ])
    }
    
    func setupRepostsCountButton() {
        repostsCountButton.setImage(repostsCountImage, for: .normal)
        repostsCountButton.tintColor = .systemGray
        
        contentView.addSubview(repostsCountButton)
        repostsCountButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            repostsCountButton.leadingAnchor.constraint(equalTo: commentsCountLabel.trailingAnchor, constant: 16),
            repostsCountButton.centerYAnchor.constraint(equalTo: commentsCountLabel.centerYAnchor)
        ])
    }
    
    func setupRepostsCountLabel() {
        repostsCountLabel.textColor = .systemGray
        repostsCountLabel.font = UIFont(name: "Roboto-Medium", size: 15)
        
        contentView.addSubview(repostsCountLabel)
        
        repostsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            repostsCountLabel.leadingAnchor.constraint(equalTo: repostsCountButton.trailingAnchor, constant: 4),
            repostsCountLabel.centerYAnchor.constraint(equalTo: repostsCountButton.centerYAnchor)
        ])
    }
}

#Preview {
    ViewController()
}
