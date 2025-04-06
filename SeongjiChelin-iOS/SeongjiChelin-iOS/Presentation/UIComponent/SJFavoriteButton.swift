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
    
    private var isHomeFavorite: Bool
    
    init(isHomeFavorite: Bool = false) {
        self.isHomeFavorite = isHomeFavorite
        super.init(frame: .zero)
        
        setFavoriteButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFavoriteButtonStyle() {
        var buttonConfiguration = UIButton.Configuration.plain()
        if isHomeFavorite {
            buttonConfiguration.title = "즐겨찾기"
            buttonConfiguration.image = UIImage(systemName: "star")
            buttonConfiguration.imagePlacement = .top
            buttonConfiguration.imagePadding = 2
            buttonConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.seongiFont(.body_bold_8)
                outgoing.foregroundColor = .text100
                return outgoing
            }
        } else {
            buttonConfiguration.image = UIImage(systemName: "star.fill")
        }
        
        self.configuration = buttonConfiguration
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.baseForegroundColor = self.isHomeFavorite ? .text100 : .bg100
                button.configuration?.background.backgroundColor = .clear
            case .selected:
                button.configuration?.baseForegroundColor = self.isHomeFavorite ? .bg100 : .primary200
                button.configuration?.background.backgroundColor = self.isHomeFavorite ? .primary200 : .clear
            default:
                return
            }
        }
        
        self.configurationUpdateHandler = buttonStateHandler
        
        if !isHomeFavorite {
            self.addTarget(self,
                           action: #selector(favoriteButtonTapped),
                           for: .touchUpInside)
            self.contentMode = .scaleAspectFit
        } else {
            self.isSelected = true
        }
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

