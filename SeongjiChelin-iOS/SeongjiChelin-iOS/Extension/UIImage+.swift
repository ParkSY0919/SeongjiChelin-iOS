//
//  UIImage+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

typealias SFConfig = UIImage.SymbolConfiguration

extension UIImage {
    
    static func plus(size: CGFloat = 16, color: UIColor = .gray) -> UIImage {
        let config = SFConfig(pointSize: size)
        let image = UIImage(systemName: "plus.app", withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image!
    }

}

