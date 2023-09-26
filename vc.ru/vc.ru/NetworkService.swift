//
//  NetworkService.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 25.09.2023.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() { }
    
    func getContent() {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil, let data = data
            else { return }
            
            self?.decode(data: data)
        }
        
        task.resume()
    }
    
    func decode(data: Data) {
        do {
            let decoder = JSONDecoder()
            let publicationData = try decoder.decode(Welcome.self, from: data)
            
            for firstNewsBlock in publicationData.result.news {
                print("Subsite name: \(firstNewsBlock.subsite?.name ?? "Error")")
                print("Subsite image url: \(firstNewsBlock.subsite?.avatar?.data?.uuid ?? "Error")")
                print("Article date: \(firstNewsBlock.date?.description ?? "Error")")
                print("Article title: \(firstNewsBlock.title ?? "Error")")
                print("Article subtitle: \(firstNewsBlock.blocks?[0].data?.text ?? "Error")")
                print("Comments count: \(firstNewsBlock.counters?.comments?.description ?? "Error")")
                print("Reposts count: \(firstNewsBlock.counters?.reposts?.description ?? "Error")")
                print("~~~~~~~~~~~~~~")
            }
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}

extension NetworkService {
    var url: URL { URL(string: "https://api.dtf.ru/v2.1/news")! }
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
}
