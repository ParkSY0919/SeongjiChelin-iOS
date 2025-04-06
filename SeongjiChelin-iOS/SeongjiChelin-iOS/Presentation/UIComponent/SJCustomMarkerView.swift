//
//  SJCustomMarkerView.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import UIKit

import SnapKit
import Then

final class CustomMarkerView: UIView {
    
    private let themeType: RestaurantThemeType
    private let iconImageView = UIImageView()
    
    init(themeType: RestaurantThemeType) {
        self.themeType = themeType
        let defaultFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        super.init(frame: defaultFrame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }
        
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .primary200
            $0.image = themeType.image
        }
        
        self.do {
            $0.backgroundColor = .bg100
            $0.layer.cornerRadius = 25/2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = themeType.color.cgColor
        }
    }
    
}

