//
//  SJStoreFilterButton.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/4/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SJStoreFilterButton: UIButton {
    
    private let image: UIImage
    let themeType: RestaurantThemeType
    let tapSubject = PublishSubject<RestaurantThemeType?>()
    
    init(theme: RestaurantThemeType) {
        self.image = theme.madeImage
        self.themeType = theme
        
        super.init(frame: .zero)
        setSJStoreFilterButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSJStoreFilterButton() {
        var config = UIButton.Configuration.plain()
        config.title = themeType.rawValue
        config.image = self.image
        config.imagePadding = 4
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.seongiFont(.body_bold_12)
            outgoing.foregroundColor = .text100
            return outgoing
        }
        self.configuration = config
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.baseForegroundColor = .bg300
                button.configuration?.background.backgroundColor = .bg100
            case .selected:
                button.configuration?.baseForegroundColor = .bg100
                button.configuration?.background.backgroundColor = self.themeType.color
            default:
                return
            }
        }
        self.configurationUpdateHandler = buttonStateHandler
        self.addTarget(
            self,
            action: #selector(SJStoreFilterButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc
    private func SJStoreFilterButtonTapped() {
        self.isUserInteractionEnabled = false
        self.isSelected.toggle()
        
        if self.isSelected {
            tapSubject.onNext(self.themeType) // 선택되면 해당 themeType 방출
        } else {
            tapSubject.onNext(nil) // 선택 해제되면 nil 방출
        }
        self.isUserInteractionEnabled = true
    }
    
}

