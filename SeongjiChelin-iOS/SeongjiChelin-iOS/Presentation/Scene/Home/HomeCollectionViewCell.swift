//
//  HomeCollectionViewCell.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/9/25.
//

import UIKit

import SnapKit
import Then

final class HomeCollectionViewCell: BaseCollectionViewCell {
    
    private let visitButton = SJButton(type: .foot, repo: RestaurantRepository())
    private let favoriteButton = SJButton(type: .favorite, repo: RestaurantRepository())
    private let storeNameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let numberLabel = UILabel()
    
    private let addressToolLabel = SJStoreInfoBaseLabelView(type: .address)
    private let storeAddressLabel = UILabel()
    private let numberToolLabel = SJStoreInfoBaseLabelView(type: .number)
    private let storeNumberLabel = UILabel()
    
    private let parkingToolLabel = SJStoreInfoBaseLabelView(type: .parking)
    private let parkingLabel = UILabel()
    
    private let openingHoursToolLabel = SJStoreInfoBaseLabelView(type: .time)
    private let openingHoursLabel = UILabel()
    
    private let menusToolLabel = SJStoreInfoBaseLabelView(type: .video)
    private let menusLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.layer.borderColor = nil
        storeNameLabel.text = nil
        categoryLabel.text = nil
        storeAddressLabel.text = nil
        storeNumberLabel.text = nil
        parkingLabel.text = nil
        menusLabel.text = nil
        menusToolLabel.isNoYoutube(isValid: true)
        openingHoursLabel.text = nil
        visitButton.isSelected = false
        favoriteButton.isSelected = false
    }
    
    override func setHierarchy() {
        contentView.addSubviews(
            visitButton,
            favoriteButton,
            storeNameLabel,
            categoryLabel,
            addressToolLabel,
            storeAddressLabel,
            numberToolLabel,
            storeNumberLabel,
            parkingToolLabel,
            parkingLabel,
            openingHoursToolLabel,
            openingHoursLabel,
            menusToolLabel,
            menusLabel
        )
    }
    
    override func setLayout() {
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            $0.size.equalTo(36)
        }
        
        visitButton.snp.makeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.bottom)
            $0.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
            $0.size.equalTo(favoriteButton.snp.size)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(favoriteButton.snp.bottom).offset(-4)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }

        categoryLabel.snp.makeConstraints {
            $0.bottom.equalTo(storeNameLabel.snp.bottom)
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualTo(visitButton.snp.leading).offset(-10)
            $0.width.greaterThanOrEqualTo(30).priority(.required)
        }
        
        addressToolLabel.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).offset(16)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(addressToolLabel.snp.top).offset(2)
            $0.leading.equalTo(addressToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
        
        numberToolLabel.snp.makeConstraints {
            //주소가 길어지면 길어진 label에 맞춰야 하기에
            $0.top.equalTo(storeAddressLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        storeNumberLabel.snp.makeConstraints {
            $0.top.equalTo(numberToolLabel.snp.top).offset(2)
            $0.leading.equalTo(numberToolLabel.snp.trailing)
        }
        
        parkingToolLabel.snp.makeConstraints {
            $0.top.equalTo(storeNumberLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        parkingLabel.snp.makeConstraints {
            $0.top.equalTo(parkingToolLabel.snp.top).offset(2)
            $0.leading.equalTo(parkingToolLabel.snp.trailing)
        }
        
        openingHoursToolLabel.snp.makeConstraints {
            $0.top.equalTo(parkingLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        openingHoursLabel.snp.makeConstraints {
            $0.top.equalTo(openingHoursToolLabel.snp.top).offset(2)
            $0.leading.equalTo(openingHoursToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
        
        menusToolLabel.snp.makeConstraints {
            $0.top.equalTo(openingHoursLabel.snp.bottom).offset(10)
            $0.leading.equalTo(addressToolLabel.snp.leading)
        }
        
        menusLabel.snp.makeConstraints {
            $0.top.equalTo(menusToolLabel.snp.top).offset(4)
            $0.leading.equalTo(menusToolLabel.snp.trailing)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func setStyle() {
        self.do {
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .cellBg
        }
        
        storeNameLabel.setLabelUI("", font: .seongiFont(.title_bold_16), textColor: .primary200)
        storeNumberLabel.setLabelUI("", font: .seongiFont(.body_bold_11), textColor: .marker4)
        
        [categoryLabel, storeAddressLabel, parkingLabel, openingHoursLabel, menusLabel].forEach { i in
            i.setLabelUI(
                "",
                font: .seongiFont(.body_bold_11),
                textColor: .accentPink,
                numberOfLines: 3
            )
        }
    }
    
    func configureCell(theme: RestaurantTheme, store: Restaurant) {
        self.layer.borderColor = theme.themeType.color.cgColor
        
        storeNameLabel.text = store.name
        categoryLabel.text = store.category
        storeAddressLabel.text = store.address
        storeNumberLabel.text = store.number
        parkingLabel.text = store.amenities
        menusLabel.text = store.menus.map(\.self).joined(separator: ", ")
        menusToolLabel.isNoYoutube(isValid: true)
        
        openingHoursLabel.do {
            let status = store.checkStoreStatus()
            $0.text = status.displayText
            $0.textColor = status.textColor
        }
        
        visitButton.configureWithRestaurant(restaurant: store)
        favoriteButton.configureWithRestaurant(restaurant: store)
    }
    
}
