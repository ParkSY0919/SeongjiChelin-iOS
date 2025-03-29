//
//  UIImageView+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

import Kingfisher

extension UIImageView {
    
    func setImageKf(with url: URL?) {
        Log.d("setImageKf 내부 url: \(url)")
        switch url == nil {
        case true:
            self.setEmptyImageView()
        case false:
            guard let url else { return }
            
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
            self.clipsToBounds = true
            self.contentMode = .scaleAspectFill
        }
    }
    
    func setImageKf(with urlString: String?, contentMode: UIView.ContentMode) {
        switch urlString == "" || urlString == nil {
        case true:
            self.setEmptyImageView()
        case false:
            guard let urlString else { return }
            
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: URL(string: urlString),
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
            self.clipsToBounds = true
            self.contentMode = contentMode
        }
    }
    
    
    
    ///nil 값 대응 공란 이미지
    func setEmptyImageView(imageStr: String? = "xmark.bin") {
        self.image = UIImage(systemName: imageStr ?? "xmark.bin")
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        self.tintColor = .gray
    }
    
}
