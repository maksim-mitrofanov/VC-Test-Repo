//
//  TimeDecoder.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 09.10.2023.
//

import Foundation

class TimeDecoder {
    private init() { }
    
    static func getDescriptionFor(unixTime: Int) -> String {
        let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
        let receivedDateInCurrentTimeZone = Date(timeIntervalSince1970: TimeInterval(unixTime + secondsFromGMT))
        let currentDateInCurrentTimeZone = Date().addingTimeInterval(TimeInterval(secondsFromGMT))
        
        let differenceInSeconds = currentDateInCurrentTimeZone.timeIntervalSince1970 - receivedDateInCurrentTimeZone.timeIntervalSince1970
        
        return getDescriptionFor(timeInterval: differenceInSeconds)
    }
    
    static func getDescriptionFor(timeInterval: TimeInterval) -> String {
        if timeInterval < 3600 {
            return "\(Int(timeInterval / 60)) минут"
        } else {
            return "\(Int(timeInterval / 3600)) часов"
        }
    }
}
