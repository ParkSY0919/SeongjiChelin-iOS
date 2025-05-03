//
//  EmptyRestaurantView.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/13/25.
//

import UIKit

import SnapKit
import Then

final class EmptyRestaurantView: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        addSubviews(
            imageView,
            titleLabel,
            descriptionLabel
        )
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        imageView.do {
            $0.image = ImageLiterals.forkKnife
            $0.tintColor = .bg300
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = "저장된 식당이 없습니다"
            $0.font = .seongiFont(.title_bold_16)
            $0.textColor = .text100
        }
        
        descriptionLabel.do {
            $0.text = "식당을 방문하거나 즐겨찾기에 추가해보세요"
            $0.font = .seongiFont(.body_regular_14)
            $0.textColor = .text200
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
    
}

