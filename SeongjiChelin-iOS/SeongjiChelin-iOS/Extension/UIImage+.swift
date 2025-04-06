//
//  UIImage+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

typealias SFConfig = UIImage.SymbolConfiguration

extension UIImage {
    
    static func riceImage(size: CGFloat = 13) -> UIImage {
        let image = UIImage(resource: .riceBowl).withRenderingMode(.alwaysTemplate)
        
        let newSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        // 새 크기로 이미지 그리기
        image.draw(in: CGRect(origin: .zero, size: newSize))
        
        // 그려진 이미지 가져오기
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        
        // 컨텍스트 종료
        UIGraphicsEndImageContext()
        
        if let resizedImage {
            return resizedImage
        } else {
            return image
        }
    }
    
    static func eyeglassesImage(size: CGFloat = 10, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "eyeglasses", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func walkImage(size: CGFloat = 10) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "figure.walk", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func cartImage(size: CGFloat = 10, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "cart", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func roadImage(size: CGFloat = 10, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "road.lanes", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func person2Image(size: CGFloat = 10, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }

}



