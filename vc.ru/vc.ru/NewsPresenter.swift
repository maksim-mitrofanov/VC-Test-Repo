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
    private(set) var imageCaches = [String : Data]()
    private(set) var presentedNews = [VCCellModel]()
    var delegate: NewsPresenterDelegate?
    
    func fetchLatestNews() {
        NetworkService.shared.presenter = self
        let lastID = presentedNews.last?.id
        NetworkService.shared.fetchNews(lastId: lastID)
    }
    
    func receiveNews(data: ServerFeedback?) {
        let decodedNews = data?.result.news.map(convert(newsModel:))
        presentedNews.append(contentsOf: decodedNews ?? [])
        
        DispatchQueue.main.async {
            self.delegate?.newsWereUpdated()
        }
    }
}

private extension NewsPresenter {
    func convert(newsModel: ServerFeedback.NewsBlock) -> VCCellModel {
        let model =  VCCellModel(
            subsiteImageUUID: newsModel.subsite.avatar.data.uuid,
            subsiteName: newsModel.subsite.name ,
            timeSincePublished: decode(unixTime: newsModel.date),
            title: newsModel.title,
            bodyText: "Error",
            mainImageUUID: "nil",
            commentsCount: newsModel.counters.comments,
            repostsCount: newsModel.counters.reposts,
            votes: newsModel.likes.summ,
            id: newsModel.id
        )
        
        return model
    }
    
    func decode(unixTime: Int) -> String {
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
