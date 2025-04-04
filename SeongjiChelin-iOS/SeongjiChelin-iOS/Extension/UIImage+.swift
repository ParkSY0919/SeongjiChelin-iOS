//
//  UIImage+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

typealias SFConfig = UIImage.SymbolConfiguration

extension UIImage {
    
    static func eyeglassesImage(size: CGFloat = 16, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "eyeglasses", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func walkImage(size: CGFloat = 16) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "figure.walk", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func cartImage(size: CGFloat = 14, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "cart", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func roadImage(size: CGFloat = 16, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "road.lanes", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }
    
    static func person2Image(size: CGFloat = 12, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "person.2.fill", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }

}



