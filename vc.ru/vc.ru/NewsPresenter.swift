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
    private(set) var presentedNews = [VCCellModel]()
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
                
                let model = VCCellModel(
                    subsiteImageData: avatarImageData,
                    subsiteName: model.subsite.name,
                    articleImageData: articleImageData,
                    timeSincePublished: NewsPresenter.decode(unixTime: model.date),
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
    
    static func decode(unixTime: Int) -> String {
        let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
        let receivedDateInCurrentTimeZone = Date(timeIntervalSince1970: TimeInterval(unixTime + secondsFromGMT))
        let currentDateInCurrentTimeZone = Date().addingTimeInterval(TimeInterval(secondsFromGMT))
        
        let differenceInSeconds = currentDateInCurrentTimeZone.timeIntervalSince1970 - receivedDateInCurrentTimeZone.timeIntervalSince1970
        
        if differenceInSeconds < 3600 {
            return "\(Int(differenceInSeconds / 60)) минут"
        } else {
            return "\(Int(differenceInSeconds / 3600)) часов"
        }
    }
}
