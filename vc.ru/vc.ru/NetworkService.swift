//
//  NetworkService.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import Foundation

final class NetworkService {    
    weak var presenter: NetworkServiceDelegate? = nil
        
    func fetchNews(lastId id: Int? = nil) {
        let request = generateNewsRequest(lastID: id)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil, let data = data
            else { return }
            
            let decodedData = self?.decode(data: data)
            self?.presenter?.receiveNews(data: decodedData)
        }
        
        task.resume()
    }
    
    func fetchAsset(uuid: String, completion: @escaping ((Data?) -> Void)) {
        let request = generateAssetsRequest(uuid: uuid)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data
            else { completion(nil); return }
            
            completion(data)
        }
        
        task.resume()
    }
}

protocol NetworkServiceDelegate: AnyObject {
    func receiveNews(data: ServerFeedback?)
}

private extension NetworkService {
    var newsUrlString: String { "https://api.dtf.ru/v2.1/news" }
    var assetsUrlString: String { "https://leonardo.osnova.io/" }
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
    
    func generateNewsRequest(lastID: Int? = nil) -> URLRequest {
        var urlComponents = URLComponents(string: newsUrlString)!
        urlComponents.queryItems = [URLQueryItem(name: "lastId", value: lastID?.description)]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        return request
    }
    
    func generateAssetsRequest(uuid: String) -> URLRequest {
        let url = URL(string: assetsUrlString + uuid)!
        let request = URLRequest(url: url)
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
