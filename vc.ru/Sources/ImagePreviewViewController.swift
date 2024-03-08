//
//  ImagePreviewViewController.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 21.02.2024.
//

import UIKit

final class ImagePreviewViewController: UIViewController, UIScrollViewDelegate {
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    private var imageData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View styling
        view.backgroundColor = .clear
        
        // Blur
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
        
        // Scroll view
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        view.addSubview(scrollView)
        
        // Image View
        imageView = UIImageView(frame: scrollView.bounds)
        imageView.image = UIImage(data: imageData, placeholder: .static_image)
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = GlobalNameSpace.vcImageView.rawValue
        scrollView.addSubview(imageView)
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPreview))
        view.addGestureRecognizer(tapGesture)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc func dismissPreview() {
        self.dismiss(animated: true)
    }
    
    func setImageData(to data: Data?) {
        imageData = data
    }
}


// Transition
extension ImagePreviewViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.4) {
            self.view.subviews[0].alpha = 1
        }
    }
}
