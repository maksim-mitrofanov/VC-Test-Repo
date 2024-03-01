//
//  HomeScreenWireframe.swift
//  vc.ru
//
//  Created by  Maksim on 29.02.24.
//

import UIKit

final class HomeScreenWireframe {
    func assemble(with networkService: HomeScreenNetworkService) -> UIViewController {
        let presenter = HomeScreenPresenter(networkService: networkService)
        let viewController = HomeScreenVC(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }
}
