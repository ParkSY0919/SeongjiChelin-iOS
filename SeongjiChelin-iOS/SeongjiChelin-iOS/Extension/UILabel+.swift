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
                    numberOfLines: Int = 1,
                    adjustsFontSizeToFitWidth: Bool = true,
                    minimumScaleFactor: CGFloat = 0.8) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.lineBreakMode = numberOfLines == 1 ? .byTruncatingTail : .byWordWrapping
        
        // 다국어 텍스트 길이 대응
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.minimumScaleFactor = minimumScaleFactor
    }
    
    // 다국어 지원을 위한 특별 메소드
    func setMultilingualText(_ text: String,
                           font: UIFont,
                           textColor: UIColor,
                           alignment: NSTextAlignment = .left,
                           maxLines: Int = 2) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
        self.numberOfLines = maxLines
        self.lineBreakMode = .byWordWrapping
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
        
        // 텍스트 길이에 따른 동적 행 수 조정
        let textLength = text.count
        if textLength > 30 {
            self.numberOfLines = maxLines
        } else if textLength > 15 {
            self.numberOfLines = min(2, maxLines)
        } else {
            self.numberOfLines = 1
        }
    }
    
}
