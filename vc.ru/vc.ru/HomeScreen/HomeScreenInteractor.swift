//
//  HomeScreenInteractor.swift
//  vc.ru
//
//  Created by  Maksim on 01.03.24.
//

import Foundation

final class HomeScreenInteractor: IHomeScreenInteractor {
    private let networkService: IHomeScreenNetworkService
    
    init(networkService: IHomeScreenNetworkService) {
        self.networkService = networkService
    }
    
    // News Fetching
    private var subsiteAvaratarCache = [String:Data?]()
    private var lastElementID: Int? = nil
    private var isFetchingNews: Bool = false
    private var decodedNews = [NewsBlockModel]()
    private var hasFinishedDecoding = false {
        didSet {
            if hasFinishedDecoding {
                decodeCompletion?(decodedNews)
                decodedNews = []
                isFetchingNews = false
                hasFinishedDecoding = false
            }
        }
    }
    private var decodeCompletion: (([NewsBlockModel]) -> Void)?
    
    func loadMoreNews(completion: @escaping (([NewsBlockModel]) -> Void)) {
        guard !isFetchingNews else { return }
        
        isFetchingNews = true
        networkService.fetchNews(lastID: lastElementID) { [weak self] serverFeedback in
            guard let news = serverFeedback?.result.news else { return }
            self?.decodeCompletion = completion
            self?.decode(models: news)
        }
    }
}

private extension HomeScreenInteractor {
    func getSubsiteAvatar(uuid: String) -> Data? {
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
    
    func decode(models: [ServerFeedback.NewsEntry]) {
        decodedNews = []
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
                
                if !self.decodedNews.contains(where: { $0.id == model.id }) {
                    self.decodedNews.append(model)
                }
                
                group.leave() // Указываем, что текущая асинхронная операция завершена
            }
        }
        
        group.notify(queue: .main) {
            self.hasFinishedDecoding = true
        }
    }
}
