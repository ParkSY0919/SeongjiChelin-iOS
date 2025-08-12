//
//  UIAlertManager.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import UIKit

final class UIAlertManager {
    
    static let shared = UIAlertManager()
    
    private init() {}
    
    func showAlert(title: String, message: String, cancelFunc: Bool? = false) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancelFunc == true {
            alert.addAction(UIAlertAction(title: StringLiterals.shared.cancel, style: .destructive))
        }
        alert.addAction(UIAlertAction(title: StringLiterals.shared.confirm, style: .default))
        
        return alert
    }
    
}
