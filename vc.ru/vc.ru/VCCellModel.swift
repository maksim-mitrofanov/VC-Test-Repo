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
    
    static let template1 = VCCellModel(subsiteImageData: nil, subsiteName: "Кино и сериалы", timeSincePublished: "1 час", title: "В Бразилии по ошибке выдали возрастной рейтинг Red Dead Redemption 2 на Switch — он предназначался для первой части", bodyText: "None", mainImageData: dummyImageData, commentsCount: 31, repostsCount: 0, votes: 1230)
    
    static let template2 = VCCellModel(subsiteImageData: nil, subsiteName: "Жизнь", timeSincePublished: "2 час", title: "Скончался актёр Майкл Гэмбон, известный по роли Дамблдора в фильмах про Гарри Поттера", bodyText: "Артисту было 82 года.", mainImageData: dummyImageData, commentsCount: 210, repostsCount: 3, votes: 542)
    
    static let template3 = VCCellModel(subsiteImageData: nil, subsiteName: "Игры", timeSincePublished: "3 час", title: "Дополнение Phantom Liberty и патч 2.0 стали последними крупными апдейтами для Cyberpunk 2077", bodyText: "Но, судя по всему, в будущем экшен-RPG получит несколько мелких обновлений.", mainImageData: dummyImageData, commentsCount: 158, repostsCount: 2, votes: 23)
    
    static let template4 = VCCellModel(subsiteImageData: nil, subsiteName: "Игры", timeSincePublished: "4 час", title: "Оригинальная Gothic вышла на Nintendo Switch", bodyText: "Со множеством исправлений и улучшенным управлением.", mainImageData: dummyImageData, commentsCount: 31, repostsCount: 2, votes: 819)
    
    static let template5 = VCCellModel(subsiteImageData: nil, subsiteName: "Спорт", timeSincePublished: "5 часов", title: "Легендарный футболист выиграл награду 'Золотой мяч' в шестой раз", bodyText: "Он продолжает показывать выдающиеся результаты на поле.", mainImageData: dummyImageData, commentsCount: 732, repostsCount: 12, votes: 4210)
    
    static let template6 = VCCellModel(subsiteImageData: nil, subsiteName: "Технологии", timeSincePublished: "6 часов", title: "Новый смартфон XYZ представлен официально", bodyText: "Устройство обладает мощным процессором и высококачественной камерой.", mainImageData: dummyImageData, commentsCount: 44, repostsCount: 5, votes: 139)
    
    static let template7 = VCCellModel(subsiteImageData: nil, subsiteName: "Здоровье", timeSincePublished: "7 часов", title: "Ученые обнаружили новый способ борьбы с хронической бессонницей", bodyText: "Исследование может привести к разработке эффективных методов лечения.", mainImageData: dummyImageData, commentsCount: 98, repostsCount: 1, votes: 872)
    
    static let template8 = VCCellModel(subsiteImageData: nil, subsiteName: "Наука", timeSincePublished: "8 часов", title: "Марсоход Perseverance обнаружил следы воды на Марсе", bodyText: "Это может свидетельствовать о возможности жизни на этой планете в прошлом.", mainImageData: dummyImageData, commentsCount: 127, repostsCount: 6, votes: 567)
    
    static let template9 = VCCellModel(subsiteImageData: nil, subsiteName: "Политика", timeSincePublished: "9 часов", title: "Новый законопроект о снижении налогов для малых предприятий", bodyText: "Предполагается, что это содействует развитию малого бизнеса.", mainImageData: dummyImageData, commentsCount: 54, repostsCount: 8, votes: 276)
    
    static let template10 = VCCellModel(subsiteImageData: nil, subsiteName: "Культура", timeSincePublished: "10 часов", title: "Выставка современного искусства откроется в музее города", bodyText: "Будут представлены работы известных художников и скульпторов.", mainImageData: dummyImageData, commentsCount: 210, repostsCount: 15, votes: 985)
    
    static let template11 = VCCellModel(subsiteImageData: nil, subsiteName: "Наука", timeSincePublished: "11 часов", title: "Обнаружена новая планета в обитаемой зоне звезды Proxima Centauri", bodyText: "Ученые рассматривают ее как потенциально подходящее место для жизни.", mainImageData: dummyImageData, commentsCount: 87, repostsCount: 3, votes: 611)
    
    static let template12 = VCCellModel(subsiteImageData: nil, subsiteName: "Здоровье", timeSincePublished: "12 часов", title: "Секреты здоровой диеты: как правильно питаться", bodyText: "Эксперты рассказывают о важности баланса и умеренности в питании.", mainImageData: dummyImageData, commentsCount: 36, repostsCount: 4, votes: 423)
    
    static let template13 = VCCellModel(subsiteImageData: nil, subsiteName: "Путешествия", timeSincePublished: "13 часов", title: "Лучшие места для отпуска в 2023 году", bodyText: "Путешествуйте и открывайте новые культуры в этом году.", mainImageData: dummyImageData, commentsCount: 189, repostsCount: 9, votes: 743)
    
    static let template14 = VCCellModel(subsiteImageData: nil, subsiteName: "Игры", timeSincePublished: "14 часов", title: "Анонс новой части игры XYZ: что ожидать от продолжения", bodyText: "Игроки ждут новых уровней и улучшенной графики.", mainImageData: dummyImageData, commentsCount: 63, repostsCount: 7, votes: 528)
    
    static let template15 = VCCellModel(subsiteImageData: nil, subsiteName: "Технологии", timeSincePublished: "15 часов", title: "Компания ABC представила инновационное устройство", bodyText: "Это устройство может изменить способ, которым мы делаем определенные задачи.", mainImageData: dummyImageData, commentsCount: 124, repostsCount: 10, votes: 939)
    
    static let template16 = VCCellModel(subsiteImageData: nil, subsiteName: "Спорт", timeSincePublished: "16 часов", title: "Финал чемпионата мира по футболу завершился в ничью", bodyText: "Команды продемонстрировали выдающиеся навыки в этом матче.", mainImageData: dummyImageData, commentsCount: 321, repostsCount: 14, votes: 1476)

    
    static let templates: [VCCellModel] = [
        .template1, .template2, .template3, .template4, .template5,
        .template6, .template7, .template8, .template9, .template10,
        .template11, .template12, .template13, .template14, .template15, .template16
    ]
}
