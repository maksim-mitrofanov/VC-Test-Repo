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

protocol NewsPresenterDelegate: AnyObject {
    func newsWereUpdated()
}

final class NewsPresenter: NetworkServiceDelegate {
    private var subsiteAvaratarCache = [String:Data?]()
    private var presentedNews = [VCCellModel]()
    private var lastElementID: Int? = nil
    weak var delegate: NewsPresenterDelegate?
    
    func fetchLatestNews() {
        NetworkService.shared.presenter = self
        NetworkService.shared.fetchNews(lastId: lastElementID)
    }
    
    func receiveNews(data: ServerFeedback?) {
        if let news = data?.result.news {
            appendToPresentedNews(models: news)
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
        lastElementID = models.last?.id
        
        models.forEach { model in
            var avatarImageData: Data? = Data()
            var articleImageData: Data? = Data()
            
            DispatchQueue.global(qos: .userInteractive).async {
                avatarImageData = self.getSubsiteAvatar(uuid: model.subsite.avatar.data.uuid)
                articleImageData = self.getSubsiteAvatar(uuid: model.getArticleImageUUID())
                
                let articleSubtitle = model.getArticleSubtitle()
                let timeDescription = TimeDecoder.getDescriptionFor(unixTime: model.date)
                
                let model = VCCellModel(
                    subsiteImageData: avatarImageData,
                    subsiteName: model.subsite.name,
                    articleImageData: articleImageData,
                    articleImageType: model.getArticleImageType(),
                    timeSincePublished: timeDescription,
                    title: model.title,
                    bodyText: articleSubtitle,
                    commentsCount: model.counters.comments,
                    repostsCount: model.counters.reposts,
                    votes: model.likes.summ,
                    id: model.id
                )
                
                #warning("Has to be fixed!")
                /*
                 When fetching content, I use model.last.id, that is later used in the NetworkService call.
                 For some reason, the data that I get back from the server may be a duplicate of the data
                 that is already present in the presented news array.
                 
                 The below if statement is a temporary fix for this bug
                 However, it should be investigated further on.
                 */
                if !self.presentedNews.contains(where: { $0.id == model.id }) {
                    self.presentedNews.append(model)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.newsWereUpdated()
                }
            }
        }
    }
}
