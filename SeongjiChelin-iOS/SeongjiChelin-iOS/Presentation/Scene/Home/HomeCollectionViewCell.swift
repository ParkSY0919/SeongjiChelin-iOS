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
    
    // MARK: - UI Components
    private let visitButton = SJButton(type: .foot, repo: RestaurantRepository())
    private let favoriteButton = SJButton(type: .favorite, repo: RestaurantRepository())
    private let storeNameLabel = UILabel()
    private let categoryLabel = UILabel()
    
    private let infoComponents: [(tool: SJStoreInfoBaseLabelView, label: UILabel, type: SJStoreInfoBaseLabelView.StoreInfoType)] = [
        (.init(type: .address), UILabel(), .address),
        (.init(type: .number), UILabel(), .number),
        (.init(type: .parking), UILabel(), .parking),
        (.init(type: .time), UILabel(), .time),
        (.init(type: .video), UILabel(), .video)
    ]
    
    // MARK: - Computed Properties
    private var addressToolLabel: SJStoreInfoBaseLabelView { return infoComponents[0].tool }
    private var storeAddressLabel: UILabel { return infoComponents[0].label }
    private var numberToolLabel: SJStoreInfoBaseLabelView { return infoComponents[1].tool }
    private var storeNumberLabel: UILabel { return infoComponents[1].label }
    private var parkingToolLabel: SJStoreInfoBaseLabelView { return infoComponents[2].tool }
    private var parkingLabel: UILabel { return infoComponents[2].label }
    private var openingHoursToolLabel: SJStoreInfoBaseLabelView { return infoComponents[3].tool }
    private var openingHoursLabel: UILabel { return infoComponents[3].label }
    private var menusToolLabel: SJStoreInfoBaseLabelView { return infoComponents[4].tool }
    private var menusLabel: UILabel { return infoComponents[4].label }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.layer.borderColor = nil
        storeNameLabel.text = nil
        categoryLabel.text = nil
        
        infoComponents.forEach { component in
            component.label.text = nil
        }
        
        menusToolLabel.isNoYoutube(isValid: true)
        visitButton.isSelected = false
        favoriteButton.isSelected = false
    }
    
    // MARK: - Setup Methods
    override func setHierarchy() {
        contentView.addSubview(visitButton)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(storeNameLabel)
        contentView.addSubview(categoryLabel)
        
        infoComponents.forEach { component in
            contentView.addSubview(component.tool)
            contentView.addSubview(component.label)
        }
    }
    
    override func setLayout() {
        setupActionButtonsLayout()
        setupHeaderLabelsLayout()
        setupInfoComponentsLayout()
    }
    
    private func setupActionButtonsLayout() {
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
    }
    
    private func setupHeaderLabelsLayout() {
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
    }
    
    private func setupInfoComponentsLayout() {
        // 첫 번째 컴포넌트 (주소) 레이아웃
        addressToolLabel.snp.makeConstraints {
            $0.top.equalTo(favoriteButton.snp.bottom).offset(16)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(addressToolLabel.snp.top).offset(2)
            $0.leading.equalTo(addressToolLabel.snp.trailing)
            $0.trailing.equalTo(favoriteButton.snp.trailing)
        }
        
        // 나머지 컴포넌트들 레이아웃 (순차적으로)
        for i in 1..<infoComponents.count {
            let prevLabel = infoComponents[i-1].label
            let currentTool = infoComponents[i].tool
            let currentLabel = infoComponents[i].label
            
            currentTool.snp.makeConstraints {
                $0.top.equalTo(prevLabel.snp.bottom).offset(10)
                $0.leading.equalTo(addressToolLabel.snp.leading)
            }
            
            // 메뉴 라벨인 경우 특별 처리
            if i == infoComponents.count - 1 {
                currentLabel.snp.makeConstraints {
                    $0.top.equalTo(currentTool.snp.top).offset(4)
                    $0.leading.equalTo(currentTool.snp.trailing)
                    $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
                }
            } else if i == 3 { // 영업시간 라벨인 경우
                currentLabel.snp.makeConstraints {
                    $0.top.equalTo(currentTool.snp.top).offset(2)
                    $0.leading.equalTo(currentTool.snp.trailing)
                    $0.trailing.equalTo(favoriteButton.snp.trailing)
                }
            } else {
                currentLabel.snp.makeConstraints {
                    $0.top.equalTo(currentTool.snp.top).offset(2)
                    $0.leading.equalTo(currentTool.snp.trailing)
                }
            }
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
        
        // 카테고리 및 정보 라벨들 스타일 통합 설정
        [categoryLabel, storeAddressLabel, parkingLabel, openingHoursLabel, menusLabel].forEach {
            $0.setLabelUI("", font: .seongiFont(.body_bold_11), textColor: .accentPink, numberOfLines: 3)
        }
    }
    
    // MARK: - Configuration Methods
    func configureCell(theme: RestaurantTheme? = nil, store: Restaurant) {
        // 테마 설정
        self.layer.borderColor = theme?.themeType.color.cgColor ?? UIColor.bg150.cgColor
        
        // 버튼 표시 설정
        let hideButtons = theme == nil
        visitButton.isHidden = hideButtons
        favoriteButton.isHidden = hideButtons
        
        // 공통 구성 작업
        storeNameLabel.text = store.name
        categoryLabel.text = store.category
        storeAddressLabel.text = store.address
        storeNumberLabel.text = store.number
        parkingLabel.text = store.amenities
        menusLabel.text = store.menus.map(\.self).joined(separator: ", ")
        menusToolLabel.isNoYoutube(isValid: true)
        
        // 영업 상태 설정
        let status = store.checkStoreStatus()
        openingHoursLabel.do {
            $0.text = status.displayText
            $0.textColor = status.textColor
        }
        
        // 버튼 구성
        visitButton.configureWithRestaurant(restaurant: store)
        favoriteButton.configureWithRestaurant(restaurant: store)
    }
}
