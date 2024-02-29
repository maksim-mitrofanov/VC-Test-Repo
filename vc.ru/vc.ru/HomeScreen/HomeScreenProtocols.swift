//
//  HomeScreenViewProtocol.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 26.02.2024.
//

import Foundation

protocol HomeScreenViewProtocol: AnyObject {
    func reloadData()
}

protocol HomeScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getCellModel(at index: Int) -> VCCellModel
    var totalCellCount: Int { get }
}

