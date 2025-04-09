//
//  SJFavoriteButton.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/4/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SJFavoriteButton: UIButton {
    
    private let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        
        setFavoriteButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFavoriteButtonStyle() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.background.backgroundColor = .primary100
        buttonConfiguration.baseForegroundColor = .bg100
        self.configuration = buttonConfiguration
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.image = UIImage(systemName: "bookmark")
            case .selected:
                button.configuration?.image = UIImage(systemName: "bookmark.fill")
            default:
                return
            }
        }
        
        self.configurationUpdateHandler = buttonStateHandler
        self.addTarget(self,
                       action: #selector(favoriteButtonTapped),
                       for: .touchUpInside)
        self.contentMode = .scaleAspectFit
        self.layer.cornerRadius = self.cornerRadius
    }
    
    @objc
    private func favoriteButtonTapped(_ button: UIButton) {
        self.isUserInteractionEnabled = false
        
        self.isSelected.toggle()
        switch self.isSelected {
        case true:
            print(#function, "create table")
        case false:
            print(#function, "delete table")
        }
        self.isUserInteractionEnabled = true
    }
    
}

