//
//  UIFont+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

extension UIFont {
    
    enum FontName {
        case body_regular_8, body_regular_10, body_regular_11, body_regular_12, body_regular_13, body_regular_14
        case body_bold_8, body_bold_10, body_bold_11, body_bold_12, body_bold_13, body_bold_14
        case body_black_8, body_black_10, body_black_11, body_black_12, body_black_13, body_black_14
        case title_bold_20
         
        var fontWeight: UIFont.Weight {
            switch self {
            case .body_regular_8, .body_regular_10, .body_regular_11, .body_regular_12, .body_regular_13, .body_regular_14:
                return .regular
            case .body_bold_8, .body_bold_10, .body_bold_11, .body_bold_12, .body_bold_13, .body_bold_14, .title_bold_20:
                return .bold
            case .body_black_8, .body_black_10, .body_black_11, .body_black_12, .body_black_13, .body_black_14:
                return .black
            }
        }
        
        var size: CGFloat {
            switch self {
            case .body_regular_8, .body_bold_8, .body_black_8:
                return 8
            case .body_regular_10, .body_bold_10, .body_black_10:
                return 10
            case .body_regular_11, .body_bold_11, .body_black_11:
                return 11
            case .body_regular_12, .body_bold_12, .body_black_12:
                return 12
            case .body_regular_13, .body_bold_13, .body_black_13:
                return 13
            case .body_regular_14, .body_bold_14, .body_black_14:
                return 14
            case .title_bold_20:
                return 20
            }
        }
    }
    
    static func seongiFont(_ style: FontName) -> UIFont {
        return UIFont.systemFont(ofSize: style.size, weight: style.fontWeight)
    }
    
}


