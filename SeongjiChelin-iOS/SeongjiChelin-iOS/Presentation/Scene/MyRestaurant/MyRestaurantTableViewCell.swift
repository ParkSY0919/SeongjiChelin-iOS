//
//  MyRestaurantTableViewCell.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/12/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class MyRestaurantTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let restaurantImageView = UIImageView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressLabel = UILabel()
    
    private let badgeStackView = UIStackView()
    private let visitedBadge = UIView()
    private let favoriteBadge = UIView()
    private let ratingBadge = UIView()
    
    private let visitedIcon = UIImageView()
    private let favoriteIcon = UIImageView()
    private let ratingIcon = UIImageView()
    private let ratingLabel = UILabel()
    
    // MARK: - Initializers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 재사용 시 데이터 초기화
        nameLabel.text = nil
        categoryLabel.text = nil
        addressLabel.text = nil
        ratingLabel.text = nil
        
        visitedBadge.isHidden = true
        favoriteBadge.isHidden = true
        ratingBadge.isHidden = true
    }
    
    // MARK: - UI Setup
    
    override func setHierarchy() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews(
            restaurantImageView,
            nameLabel,
            categoryLabel,
            addressLabel,
            badgeStackView
        )
        
        visitedBadge.addSubview(visitedIcon)
        favoriteBadge.addSubview(favoriteIcon)
        ratingBadge.addSubviews(ratingIcon, ratingLabel)
        
        badgeStackView.addArrangedSubview(visitedBadge)
        badgeStackView.addArrangedSubview(favoriteBadge)
        badgeStackView.addArrangedSubview(ratingBadge)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        restaurantImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(containerView.snp.height)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(restaurantImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        badgeStackView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(24)
        }
        
        // 배지 내부 아이콘 레이아웃
        [visitedIcon, favoriteIcon, ratingIcon].forEach { icon in
            icon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(6)
                $0.size.equalTo(16)
            }
        }
        
        ratingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(ratingIcon.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().offset(-6)
        }
    }
    
    override func setStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .bg200
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        restaurantImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .bg300
            $0.image = UIImage(systemName: "fork.knife")
            $0.tintColor = .bg300
        }
        
        nameLabel.do {
            $0.font = .seongiFont(.title_bold_16)
            $0.textColor = .text100
        }
        
        categoryLabel.do {
            $0.font = .seongiFont(.body_regular_14)
            $0.textColor = .text200
        }
        
        addressLabel.do {
            $0.font = .seongiFont(.body_regular_12)
            $0.textColor = .text200
            $0.numberOfLines = 1
        }
        
        badgeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .fillProportionally
        }
        
        // 배지 스타일 설정
        [visitedBadge, favoriteBadge, ratingBadge].forEach { badge in
            badge.do {
                $0.backgroundColor = .primary100.withAlphaComponent(0.2)
                $0.layer.cornerRadius = 12
                $0.clipsToBounds = true
                $0.isHidden = true
            }
        }
        
        // 배지 내부 요소 설정
        visitedIcon.do {
            $0.image = UIImage(resource: .footFill).withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .primary100
        }
        
        favoriteIcon.do {
            $0.image = UIImage(systemName: "bookmark.fill")
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .primary100
        }
        
        ratingIcon.do {
            $0.image = UIImage(systemName: "star.fill")
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .primary100
        }
        
        ratingLabel.do {
            $0.font = .seongiFont(.body_bold_12)
            $0.textColor = .primary100
        }
        
        // 배지 너비 설정
        visitedBadge.snp.makeConstraints {
            $0.width.equalTo(28)
        }
        
        favoriteBadge.snp.makeConstraints {
            $0.width.equalTo(28)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with restaurant: RestaurantTable) {
        nameLabel.text = restaurant.name
        categoryLabel.text = restaurant.category
        addressLabel.text = restaurant.address
        
        // 배지 표시
        visitedBadge.isHidden = !restaurant.isVisited
        favoriteBadge.isHidden = !restaurant.isFavorite
        
        // 평점 표시
        if let rating = restaurant.rating {
            ratingBadge.isHidden = false
            ratingLabel.text = String(format: "%.1f", rating)
            
            // 평점 배지 너비 동적 조정
            ratingBadge.snp.makeConstraints {
                $0.width.equalTo(48)
            }
        } else {
            ratingBadge.isHidden = true
        }
    }
} 
