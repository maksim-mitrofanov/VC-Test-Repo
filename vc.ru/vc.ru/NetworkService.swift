//
//  NetworkService.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    weak var presenter: NewsPresenter? = nil
        
    func fetchContent(with id: Int? = nil) {
        let request = generateURLRequest(lastID: id)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil, let data = data
            else { return }
            
            let decodedData = self?.decode(data: data)
            self?.presenter?.receive(data: decodedData)
        }
        
        task.resume()
    }
}

private extension NetworkService {
    var urlString: String { "https://api.dtf.ru/v2.1/news" }
    var appName: String  { "dtf-app" }
    var appVersion: String  { "2.2.0" }
    var appBuildType: String  { "release" }
    var deviceName: String  { "Pixel 2" }
    var osName: String  { "Android" }
    var osVersion: String  { "9" }
    var locale: String  { "ru_RU" }
    var screenHeight: String  { "1980" }
    var screenWidth: String  { "1794" }
    
    var userAgent: String {
        "\(appName)-app/\(appVersion); \(appBuildType) (\(deviceName); \(osName)/\(osVersion); \(locale); \(screenHeight)x\(screenWidth)"
    }
    
    func generateURLRequest(lastID: Int? = nil) -> URLRequest {
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = [URLQueryItem(name: "lastId", value: lastID?.description)]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        return request
    }
    
    func decode(data: Data) -> ServerFeedback? {
        do {
            let decoder = JSONDecoder()
            let publicationData = try decoder.decode(ServerFeedback.self, from: data)
            
            return publicationData
        } catch {
            return nil
        }
    }
}
