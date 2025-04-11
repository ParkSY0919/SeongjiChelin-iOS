//
//  SJButton.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/4/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SJButton: UIButton {
    
    enum SJButtonType {
        case favorite
        case foot
        
        var cornerRadius: CGFloat {
            switch self {
            case .favorite:
                35/2
            case .foot:
                35/2
            }
        }
    }
    
    private let type: SJButtonType
    
    init(type: SJButtonType) {
        self.type = type
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
                switch self.type {
                case .favorite:
                    button.configuration?.image = UIImage(systemName: "bookmark")
                case .foot:
                    let image = UIImage(resource: .foot).withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 26, height: 26))
                    button.configuration?.image = image
                }
            case .selected:
                switch self.type {
                case .favorite:
                    button.configuration?.image = UIImage(systemName: "bookmark.fill")
                case .foot:
                    let image = UIImage(resource: .footFill).withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 26, height: 26))
                    button.configuration?.image = image
                }
            default:
                return
            }
        }
        self.configurationUpdateHandler = buttonStateHandler
        self.addTarget(self,
                       action: #selector(sjButtonTapped),
                       for: .touchUpInside)
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        self.layer.cornerRadius = type.cornerRadius
    }
    
    @objc
    private func sjButtonTapped(_ button: UIButton) {
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

