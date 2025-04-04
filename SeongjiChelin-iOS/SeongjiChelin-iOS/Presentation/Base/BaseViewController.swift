//
//  BaseViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/29/25.
//

import UIKit

import SnapKit
import Then
import Toast

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {}
    
    func setLayout() {}
    
    func setStyle() {}
    
    ///normal Toast
    func showToast(message: String, isNetworkToast: Bool = false) {
        var style = ToastStyle()
        style.messageFont = .seongiFont(.body_bold_13)
        style.backgroundColor = .accentBeige
        style.messageColor = .text100
        style.cornerRadius = 10
        
        let duration: Double = isNetworkToast ? 1 : 2.5
        view.makeToast(message, duration: duration, position: .bottom, style: style)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
