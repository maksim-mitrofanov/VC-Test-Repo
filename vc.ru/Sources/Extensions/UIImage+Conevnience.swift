//
//  UIImage+Conevnience.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 01.10.2023.
//

import UIKit

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
    convenience init?(data: Data?, placeholder: UIImagePlaceholderName) {
        if let data {
            self.init(data: data)
        } else {
            self.init(named: placeholder.description)
        }
    }
    
    convenience init?(placeholder: UIImagePlaceholderName) {
        self.init(named: placeholder.description)
    }
    
    
    enum UIImagePlaceholderName {
        case gif
        case static_image
        
        var description: String {
            switch self {
            case .gif:
                return "gif_placeholder"
            case .static_image:
                return "static_image_placeholder"
            }
        }
    }
}
