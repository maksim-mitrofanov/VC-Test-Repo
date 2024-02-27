//
//  HomeScreenPresenter.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 02.10.2023.
//

import UIKit

protocol NetworkServiceDelegate: AnyObject {
    func receiveNews(data: ServerFeedback?)
}

protocol NewsPresenterDelegate: AnyObject {
    func newsWereUpdated()
}

final class HomeScreenPresenter: NetworkServiceDelegate {
    private var subsiteAvaratarCache = [String:Data?]()
    private var lastElementID: Int? = nil
    
    private var presentedNews = [VCCellModel]()
    
    weak var viewInput: HomeScreenInput? {
        didSet {
            viewInput?.getNews = { [weak self] in
                self?.fetchLatestNews()
            }
        }
    }
    
    func fetchLatestNews() {
        viewInput?.display(news: presentedNews)
        NetworkService.shared.presenter = self
        NetworkService.shared.fetchNews(lastId: lastElementID)
    }
    
    func receiveNews(data: ServerFeedback?) {
        if let news = data?.result.news {
            appendToPresentedNews(models: news)
        }
    }
    
    init() {
        presentedNews = [.empty, .empty]
    }
}

private extension HomeScreenPresenter {
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
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 2) {
            
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
                
                if let firstEmptyCellIndex = self.presentedNews.firstIndex(of: .empty) {
                    self.presentedNews[firstEmptyCellIndex] = model
                }
                
                else if !self.presentedNews.contains(where: { $0.id == model.id }) {
                    self.presentedNews.append(model)
                }
                
                DispatchQueue.main.async {
                    self.viewInput?.display(news: self.presentedNews)
                }
            }
        }
    }
}
