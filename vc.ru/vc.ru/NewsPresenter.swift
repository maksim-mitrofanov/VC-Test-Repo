//
//  NewsPresenter.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 02.10.2023.
//

import UIKit
import Foundation

protocol NetworkServiceDelegate: AnyObject {
    func receiveNews(data: ServerFeedback?)
}

protocol NewsPresenterDelegate {
    func newsWereUpdated()
}

final class NewsPresenter: NetworkServiceDelegate {
    private var subsiteAvaratarCache = [String:Data?]()
    private var presentedNews = [VCCellModel]()
    var delegate: NewsPresenterDelegate?
    
    func fetchLatestNews() {
        NetworkService.shared.presenter = self
        let lastID = presentedNews.last?.id
        NetworkService.shared.fetchNews(lastId: lastID)
    }
    
    func receiveNews(data: ServerFeedback?) {
        if let news = data?.result.news {
            appendToPresentedNews(models: news)
        }
        
        DispatchQueue.main.async {
            self.delegate?.newsWereUpdated()
        }
    }
    
    func getCell(at index: Int) -> VCCellModel {
        if index == (cellCount - 1) {
            fetchLatestNews()
        }
        return presentedNews[index]
    }
    
    var cellCount: Int {
        presentedNews.count
    }
}

private extension NewsPresenter {
    func getSubsiteAvatar(uuid: String) -> Data? {
        var avatarData: Data? = nil
        
        if let cachedData = subsiteAvaratarCache[uuid] { avatarData = cachedData }
        else {
            let group = DispatchGroup()
            
            group.enter()
            NetworkService.shared.fetchAsset(uuid: uuid) { fetchedData in
                avatarData = fetchedData
                self.subsiteAvaratarCache[uuid] = fetchedData
                group.leave()
            }
            
            group.wait()
        }
        
        return avatarData
    }
    
    func appendToPresentedNews(models: [ServerFeedback.NewsEntry]) {
        models.forEach { model in
            DispatchQueue.main.async {
                let avatarImageData = self.getSubsiteAvatar(uuid: model.subsite.avatar.data.uuid)
                let articleImageData = self.getSubsiteAvatar(uuid: model.getArticleImageUUID())
                let articleSubtitle = model.getArticleSubtitle()
                let timeDescription = TimeDecoder.getDescriptionFor(unixTime: model.date)
                
                let model = VCCellModel(
                    subsiteImageData: avatarImageData,
                    subsiteName: model.subsite.name,
                    articleImageData: articleImageData,
                    timeSincePublished: timeDescription,
                    title: model.title,
                    bodyText: articleSubtitle,
                    commentsCount: model.counters.comments,
                    repostsCount: model.counters.reposts,
                    votes: model.likes.summ,
                    id: model.id
                )
                
                self.presentedNews.append(model)
            }
        }
    }
}
