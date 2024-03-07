//
//  HomeScreenWireframe.swift
//  vc.ru
//
//  Created by  Maksim on 29.02.24.
//

import UIKit

final class HomeScreenWireframe {
    func assemble(with networkService: IHomeScreenNetworkService) -> UIViewController {
        let interactor = HomeScreenInteractor(networkService: networkService)
        let presenter = HomeScreenPresenter(interactor: interactor)
        let viewController = HomeScreenVC(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }
}
