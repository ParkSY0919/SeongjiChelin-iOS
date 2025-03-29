//
//  UIStackView+.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//


import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
}
