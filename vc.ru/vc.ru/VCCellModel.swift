//
//  VCCellModel.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 28.09.2023.
//

import UIKit
import Foundation

struct VCCellModel: Identifiable {
    let subsiteImageData: Data?
    let subsiteName: String
    let timeSincePublished: String
    let title: String
    let bodyText: String
    let mainImageData: Data
    let commentsCount: Int
    let repostsCount: Int
    let votes: Int
    
    let id = UUID()
}

extension VCCellModel {
    static let dummyImageData = UIImage(named: "demo_image")!.jpegData(compressionQuality: 1)!
    
    static let template1 = VCCellModel(subsiteImageData: nil, subsiteName: "Кино и сериалы", timeSincePublished: "1 час", title: "В Бразилии по ошибке выдали возрастной рейтинг Red Dead Redemption 2 на Switch — он предназначался для первой части", bodyText: "None", mainImageData: dummyImageData, commentsCount: 31, repostsCount: 0, votes: 0)
    
    static let template2 = VCCellModel(subsiteImageData: nil, subsiteName: "Жизнь", timeSincePublished: "2 час", title: "Скончался актёр Майкл Гэмбон, известный по роли Дамблдора в фильмах про Гарри Поттера", bodyText: "Артисту было 82 года.", mainImageData: dummyImageData, commentsCount: 210, repostsCount: 3, votes: 0)
    
    static let template3 = VCCellModel(subsiteImageData: nil, subsiteName: "Игры", timeSincePublished: "3 час", title: "Дополнение Phantom Liberty и патч 2.0 стали последними крупными апдейтами для Cyberpunk 2077", bodyText: "Но, судя по всему, в будущем экшен-RPG получит несколько мелких обновлений.", mainImageData: dummyImageData, commentsCount: 158, repostsCount: 2, votes: 0)
    
    static let template4 = VCCellModel(subsiteImageData: nil, subsiteName: "Игры", timeSincePublished: "4 час", title: "Оригинальная Gothic вышла на Nintendo Switch", bodyText: "Со множеством исправлений и улучшенным управлением.", mainImageData: dummyImageData, commentsCount: 31, repostsCount: 2, votes: 0)
    
    static let templates: [VCCellModel] = [.template1, .template2, .template3, .template4]
}
