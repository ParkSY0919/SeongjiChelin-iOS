//
//  UILabel+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import UIKit

extension UILabel {
    
    // 기본 라벨 속성 설정 메소드
    func setLabelUI(_ text: String,
                    font: UIFont,
                    textColor: UIColor,
                    alignment: NSTextAlignment = .left,
                    numberOfLines: Int = 1) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = .byTruncatingTail
    }
    
}
