//
//  VCTableViewCell.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import UIKit

class VCTableViewCell: UITableViewCell {
    static let id = GlobalNameSpace.vcHomeScreenTableViewCell.rawValue
    static let accessibilityIdentifier = GlobalNameSpace.vcHomeScreenTableViewCell.rawValue
                    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAllSubviews()
        contentView.backgroundColor = UIColor.white
        self.accessibilityIdentifier = VCTableViewCell.accessibilityIdentifier
    }

    func setup(from displayedModel: NewsBlockModel) {
        updateDisplayedModel(to: displayedModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Views
    lazy private var subsiteImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var articleImageView: UIImageView = {
        return UIImageView()
    }()
    
    // Views
    private let subsiteNameLabel = UILabel()
    private let timeSincePublishedLabel = UILabel()
    private let showMoreOptionsButton = UIButton()
    private let articleTitleLabel = UILabel()
    private let articleBodyLabel = UILabel()
    private let leaveCommentButton = UIButton()
    private let commentsCountLabel = UILabel()
    private let repostArticleButton = UIButton()
    private let repostsCountLabel = UILabel()
    private let saveArticleButton = UIButton()
    private let voteUpButton = UIButton()
    private let voteDownButton = UIButton()
    private let totalVotesCountLabel = UILabel()
    
    // StackViews
    let topStackView = UIStackView()
    let titleAndBodyStackView = UIStackView()
    let feedbackControlsStackView = UIStackView()
}

private extension VCTableViewCell {
    func setupAllSubviews() {
        styleSubsiteImage()
        styleSubsiteNameLabel()
        stylePublishedTimeLabel()
        styleShowMoreOptionsButton()
        styleArticleTitleLabel()
        styleArticleBodyLabel()
        setupTopStackView()
        setupArticleTitleAndSubtitle()
        setupArticleImage()
        setupFeedbackControlsStackView()
    }
    
    func updateDisplayedModel(to model: NewsBlockModel) {
        subsiteNameLabel.text = model.subsiteName
        timeSincePublishedLabel.text = model.timeSincePublished
        articleTitleLabel.text = model.title
        articleBodyLabel.text = model.bodyText
        commentsCountLabel.text = model.commentsCount?.description
        repostsCountLabel.text = model.repostsCount?.description
        totalVotesCountLabel.text = model.votes?.description
        
        if let subsiteAvatarData = model.subsiteImageData {
            subsiteImageView.image = UIImage(data: subsiteAvatarData)
        }
        if model.articleImageType.lowercased() == "gif" {
            articleImageView.image = UIImage(placeholder: .gif)
        } else if let articleImageData = model.articleImageData {
            articleImageView.image = UIImage(data: articleImageData)
        }
    }
    
    func setupArticleTitleAndSubtitle() {
        titleAndBodyStackView.axis = .vertical
        titleAndBodyStackView.spacing = 8
        titleAndBodyStackView.addArrangedSubview(articleTitleLabel)
        titleAndBodyStackView.addArrangedSubview(articleBodyLabel)
        
        contentView.addSubview(titleAndBodyStackView)
        
        titleAndBodyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleAndBodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleAndBodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleAndBodyStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16)
        ])
    }
    
    func styleArticleTitleLabel() {
        articleTitleLabel.font = .header1
        articleTitleLabel.textColor = .black
        articleTitleLabel.numberOfLines = 0
    }
    
    func styleArticleBodyLabel()  {
        articleBodyLabel.font = .body3Reg
        articleBodyLabel.textColor = .black
        articleBodyLabel.numberOfLines = 0
    }
    
    func styleSubsiteNameLabel() {
        subsiteNameLabel.textColor = .black
        subsiteNameLabel.numberOfLines = 0
        subsiteNameLabel.font = .body3Med
    }
    
    func styleSubsiteImage() {
        subsiteImageView.clipsToBounds = true
        subsiteImageView.backgroundColor = .clear
        subsiteImageView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            subsiteImageView.widthAnchor.constraint(equalToConstant: 22),
            subsiteImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func stylePublishedTimeLabel() {
        timeSincePublishedLabel.font = .body3Reg
        timeSincePublishedLabel.textColor = .darkGray
    }
    
    func styleShowMoreOptionsButton()  {
        let showMoreOptionsImage = UIImage(systemName: "ellipsis")
        showMoreOptionsButton.setImage(showMoreOptionsImage, for: .normal)
        showMoreOptionsButton.tintColor = .systemGray
        showMoreOptionsButton.layer.cornerRadius = 5
    }
    
    
    func setupArticleImage() {
        setupArticleImageTapGesture()
        articleImageView.backgroundColor = .clear
        
        contentView.addSubview(articleImageView)
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleImageView.heightAnchor.constraint(equalToConstant: 210),
            articleImageView.topAnchor.constraint(equalTo: titleAndBodyStackView.bottomAnchor, constant: 16),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setupArticleImageTapGesture() {
        articleImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        articleImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {

    }
    
    func setupTopStackView() {
        contentView.addSubview(topStackView)
        
        let subsiteInfoStackView = UIStackView()
        subsiteInfoStackView.axis = .horizontal
        subsiteInfoStackView.alignment = .center
        subsiteInfoStackView.spacing = 8
        
        subsiteInfoStackView.addArrangedSubview(subsiteImageView)
        subsiteInfoStackView.addArrangedSubview(subsiteNameLabel)
        subsiteInfoStackView.addArrangedSubview(timeSincePublishedLabel)
        subsiteInfoStackView.setCustomSpacing(12, after: subsiteNameLabel)
                
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        topStackView.spacing = 8
        
        topStackView.addArrangedSubview(subsiteInfoStackView)
        topStackView.addArrangedSubview(showMoreOptionsButton)

        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupFeedbackControlsStackView() {
        let commentsStackView = getCommentsStackView()
        let repostsStackView = getRepostsStackView()
        let savePostButton = getSavePostButton()
        let votesStackView = getVotesStackView()
        
        let interactionsStackView = UIStackView()
        interactionsStackView.axis = .horizontal
        interactionsStackView.spacing = 20
        interactionsStackView.alignment = .leading
        
        interactionsStackView.addArrangedSubview(commentsStackView)
        interactionsStackView.addArrangedSubview(repostsStackView)
        interactionsStackView.addArrangedSubview(savePostButton)
               
        contentView.addSubview(feedbackControlsStackView)
        feedbackControlsStackView.axis = .horizontal
        feedbackControlsStackView.alignment = .center
        feedbackControlsStackView.distribution = .equalSpacing
        
        feedbackControlsStackView.addArrangedSubview(interactionsStackView)
        feedbackControlsStackView.addArrangedSubview(votesStackView)
        
        feedbackControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feedbackControlsStackView.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 16),
            feedbackControlsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            feedbackControlsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        let footerView = cellFooterView
        contentView.addSubview(footerView)
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: feedbackControlsStackView.bottomAnchor, constant: 16),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            footerView.heightAnchor.constraint(equalToConstant: 20),
            footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    func getVotesStackView() -> UIStackView {
        let votesStackView = UIStackView()
        votesStackView.axis = .horizontal
        votesStackView.alignment = .trailing
        votesStackView.spacing = 6.5
        
        let voteDownButton = UIButton(type: .system)
        let voteDownImage = UIImage(systemName: "chevron.down")
        voteDownButton.setImage(voteDownImage, for: .normal)
        voteDownButton.tintColor = .customSecondaryGray
        voteDownButton.layer.cornerRadius = 5
        
        let voteUpButton = UIButton(type: .system)
        let voteUpImage = UIImage(systemName: "chevron.up")
        voteUpButton.setImage(voteUpImage, for: .normal)
        voteUpButton.tintColor = .customSecondaryGray
        voteUpButton.layer.cornerRadius = 5
        
        totalVotesCountLabel.textColor = .customSecondaryGray
        totalVotesCountLabel.font = .body3Med
        
        votesStackView.addArrangedSubview(voteDownButton)
        votesStackView.addArrangedSubview(totalVotesCountLabel)
        votesStackView.addArrangedSubview(voteUpButton)
        
        return votesStackView
    }
    
    func getSavePostButton() -> UIButton {
        let savePostButton = UIButton(type: .system)
        let savePostImage = UIImage(named: "save_post_icon")
        let resizedImage = savePostImage?.scalePreservingAspectRatio(targetSize: iconTargetSize)
        savePostButton.setImage(resizedImage, for: .normal)
        savePostButton.tintColor = .customSecondaryGray
        savePostButton.layer.cornerRadius = buttonCornerRadius
        
        return savePostButton
    }
    
    func getRepostsStackView() -> UIStackView {
        let repostsStackView = UIStackView()
        repostsStackView.axis = .horizontal
        repostsStackView.alignment = .center
        repostsStackView.spacing = 4
        
        let repostsCountImage = UIImage(named: "repost_icon")
        let resizedImage = repostsCountImage?.scalePreservingAspectRatio(targetSize: iconTargetSize)
        let repostsCountButton = UIButton(type: .system)
        repostsCountButton.setImage(resizedImage, for: .normal)
        repostsCountButton.tintColor = .customSecondaryGray
        repostsCountButton.layer.cornerRadius = buttonCornerRadius
        
        repostsCountLabel.font = .body3Med
        repostsCountLabel.textColor = .customSecondaryGray
        
        repostsStackView.addArrangedSubview(repostsCountButton)
        repostsStackView.addArrangedSubview(repostsCountLabel)
        
        return repostsStackView
    }
    
    func getCommentsStackView() -> UIStackView {
        let commentsStackView = UIStackView()
        commentsStackView.axis = .horizontal
        commentsStackView.alignment = .center
        commentsStackView.spacing = 4
        
        let commentsCountImage = UIImage(named: "comments_icon")
        let resizedImage = commentsCountImage?.scalePreservingAspectRatio(targetSize: iconTargetSize)
        let commentsCountButton = UIButton(type: .system)
        commentsCountButton.setImage(resizedImage, for: .normal)
        commentsCountButton.tintColor = .customSecondaryGray
        commentsCountButton.layer.cornerRadius = buttonCornerRadius
        
        commentsCountLabel.font = .body3Med
        commentsCountLabel.textColor = .customSecondaryGray
        commentsStackView.addArrangedSubview(commentsCountButton)
        commentsStackView.addArrangedSubview(commentsCountLabel)
        
        return commentsStackView
    }
        
    var cellFooterView: UIView {
        let footerView = UIView()
        footerView.backgroundColor = footerBackgroundColor
        return footerView
    }
}

// MARK: - Layout Values
extension VCTableViewCell {
    private var footerBackgroundColor: UIColor { .lightGray.withAlphaComponent(0.1) }
    private var buttonCornerRadius: CGFloat { 10 }
    private var iconTargetSize: CGSize { CGSize(width: 22, height: 22) }
}
