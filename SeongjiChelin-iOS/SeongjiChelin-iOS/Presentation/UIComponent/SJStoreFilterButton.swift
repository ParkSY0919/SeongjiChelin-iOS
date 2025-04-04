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
    
    enum RestaurantTheme: String {
        case psyTheme = "주인장's Pick"
        case sungSiKyungTheme = "성시경의 먹을텐데"
        case ttoGanJibTheme = "풍자의 또간집"
        case hongSeokCheonTheme = "홍석천과 이원일"
        case baekJongWonTheme = "백종원의 님아 그 시장을 가오"
    }
    
    private let image: UIImage
    private let theme: RestaurantTheme
    let tapSubject = PublishSubject<SJStoreFilterButton>()
    
    init(image: UIImage, theme: RestaurantTheme) {
        self.image = image
        self.theme = theme
        
        super.init(frame: .zero)
        setSJStoreFilterButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSJStoreFilterButton() {
        var config = UIButton.Configuration.plain()
        config.title = theme.rawValue
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
                button.configuration?.baseForegroundColor = .text100
                button.configuration?.background.backgroundColor = .bg300
            case .selected:
                button.configuration?.baseForegroundColor = .bg100
                button.configuration?.background.backgroundColor = .primary200
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
    func SJStoreFilterButtonTapped() {
        self.isUserInteractionEnabled = false
        
        self.isSelected.toggle()
        switch self.isSelected {
        case true:
            tapSubject.onNext(self)
        case false:
            print(#function, "\(self.theme) 선택 취소")
        }
        
        self.isUserInteractionEnabled = true
    }
    
}

