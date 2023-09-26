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
        let url = URL(string: "https://api.dtf.ru/v2.1/news")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let appName = "dtf-app"
        let appVersion = "2.2.0"
        let appBuildType = "release"
        let deviceName = "Pixel 2"
        let osName = "Android"
        let osVersion = "9"
        let locale = "ru_RU"
        let screenHeight = "1980"
        let screenWidth = "1794"
        
        let userAgent = "\(appName)-app/\(appVersion); \(appBuildType) (\(deviceName); \(osName)/\(osVersion); \(locale); \(screenHeight)x\(screenWidth)"
        
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle the error
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                // Handle the case where no data was returned
                print("No data received")
                return
            }
            
            // Parse and handle the data here (e.g., decoding JSON)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(json)")
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
