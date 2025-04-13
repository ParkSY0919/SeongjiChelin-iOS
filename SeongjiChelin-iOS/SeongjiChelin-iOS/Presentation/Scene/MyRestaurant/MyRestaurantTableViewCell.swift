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
    private let line = UIView()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let addressLabel = UILabel()
    
    // MARK: - Initializers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        categoryLabel.text = nil
        addressLabel.text = nil
    }
    
    // MARK: - UI Setup
    
    override func setHierarchy() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews(
            restaurantImageView,
            line,
            nameLabel,
            categoryLabel,
            addressLabel
        )
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        restaurantImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        line.snp.makeConstraints {
            $0.leading.equalTo(restaurantImageView.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(4)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(line.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(addressLabel.snp.top).offset(-4)
            $0.leading.equalTo(nameLabel)
        }
        
        addressLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func setStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .cellBg
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        line.backgroundColor = .bg100
        
        restaurantImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.image = UIImage(systemName: "fork.knife")
            $0.tintColor = .primary100
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
    }
    
    // MARK: - Public Methods
    
    func configure(with restaurant: RestaurantTable) {
        nameLabel.text = restaurant.name
        categoryLabel.text = restaurant.category
        addressLabel.text = restaurant.address
    }
    
}
