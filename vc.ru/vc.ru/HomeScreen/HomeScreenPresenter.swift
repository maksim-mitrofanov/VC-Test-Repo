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

final class HomeScreenPresenter: HomeScreenPresenterProtocol, NetworkServiceDelegate {
    private var subsiteAvaratarCache = [String:Data?]()
    private var lastElementID: Int? = nil
    
    private var presentedNews = [VCCellModel]()
    
    weak var viewInput: HomeScreenInput? 
    
    func fetchNews() {
        if presentedNews.count == 0 {
            presentedNews = [.empty, .empty]
            viewInput?.display(news: presentedNews)
            NetworkService.shared.presenter = self
        }
        
        NetworkService.shared.fetchNews(lastId: lastElementID)
    }
    
    func receiveNews(data: ServerFeedback?) {
        if let news = data?.result.news {
            appendToPresentedNews(models: news)
        }
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
        
        let group = DispatchGroup() // Создаем новую группу диспетчеризации
        
        models.forEach { model in
            var avatarImageData: Data? = Data()
            var articleImageData: Data? = Data()
            
            group.enter() // Указываем, что начинаем новую асинхронную операцию
            
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
                
                if let firstEmptyCellIndex = self.presentedNews.firstIndex(of: .empty) {
                    self.presentedNews[firstEmptyCellIndex] = model
                }
                else if !self.presentedNews.contains(where: { $0.id == model.id }) {
                    self.presentedNews.append(model)
                }
                
                group.leave() // Указываем, что текущая асинхронная операция завершена
            }
        }
        
        group.notify(queue: .main) {
            self.viewInput?.display(news: self.presentedNews)
        }
    }
}
