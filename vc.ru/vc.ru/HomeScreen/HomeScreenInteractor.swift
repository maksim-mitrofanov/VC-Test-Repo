//
//  HomeScreenInteractor.swift
//  vc.ru
//
//  Created by  Maksim on 01.03.24.
//

import Foundation

final class HomeScreenInteractor: HomeScreenViewInteractor {
    private let networkService: HomeScreenViewNetworkService
    
    init(networkService: HomeScreenViewNetworkService) {
        self.networkService = networkService
    }
    
    // News Fetching
    private var subsiteAvaratarCache = [String:Data?]()
    private var lastElementID: Int? = nil
    private var isFetchingNews: Bool = false
    
    func loadMoreNews(completion: @escaping (([NewsBlockModel]) -> Void)) {
        guard !isFetchingNews else { return }
        
        isFetchingNews = true
        networkService.fetchNews(lastID: lastElementID) { [weak self] serverFeedback in
            guard let news = serverFeedback?.result.news else { return }
            guard let decodedNews = self?.decode(models: news) else { return }
            completion(decodedNews)
        }
    }
    
    // Caching
    private func fetchAsset(uuid: String) -> Data? {
        var avatarData: Data? = nil
        
        if let cachedData = subsiteAvaratarCache[uuid] { avatarData = cachedData }
        else {
            let group = DispatchGroup()
            
            group.enter()
            networkService.fetchAsset(uuid: uuid) { fetchedData in
                avatarData = fetchedData
                self.subsiteAvaratarCache[uuid] = fetchedData
                group.leave()
            }
            
            group.wait()
        }
        
        return avatarData
    }
    
    private func decode(models: [ServerFeedback.NewsEntry]) -> [NewsBlockModel] {
        lastElementID = models.last?.id
        
        let group = DispatchGroup()
        var decodedModels = [NewsBlockModel]()
        
        models.forEach { model in
            var avatarImageData: Data? = Data()
            var articleImageData: Data? = Data()
            
            group.enter() // Указываем, что начинаем новую асинхронную операцию
            
            DispatchQueue.global(qos: .userInteractive).async {
                
//                avatarImageData = self.fetchAsset(uuid: model.subsite.avatar.data.uuid)
//                articleImageData = self.fetchAsset(uuid: model.getArticleImageUUID())
                
                let articleSubtitle = model.getArticleSubtitle()
                let timeDescription = TimeDecoder.getDescriptionFor(unixTime: model.date)
                
                let model = NewsBlockModel(
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
                
                if !decodedModels.contains(where: { $0.id == model.id }) {
                    decodedModels.append(model)
                }
                
                group.leave() // Указываем, что текущая асинхронная операция завершена
            }
            
            group.wait()
        }
        
        isFetchingNews = false
        return decodedModels
    }
}
