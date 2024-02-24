//
//  VCTableViewCell.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 24.02.2024.
//

import UIKit

protocol VCTableViewCell: UITableViewCell {
    var imageWasTapped: (() -> Void)? { get set }
}
