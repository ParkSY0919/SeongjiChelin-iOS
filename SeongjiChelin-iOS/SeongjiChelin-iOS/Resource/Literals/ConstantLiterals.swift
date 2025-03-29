//
//  ConstantLiterals.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

struct ConstantLiterals {
    
    enum ScreenSize {
        static var width: CGFloat {
            guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                fatalError()
            }
            return window.screen.bounds.width
        }
        
        static var height: CGFloat {
            guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                fatalError()
            }
            return window.screen.bounds.height
        }
    }
    
}

