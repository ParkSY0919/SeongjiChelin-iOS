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
import RealmSwift

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
    private let repo: RestaurantRepositoryProtocol = RestaurantRepository()
    private var restaurantInfo: Restaurant?
    var onChangeState: (() -> ())?
    
    init(type: SJButtonType) {
        self.type = type
        super.init(frame: .zero)
        repo.getFileURL()
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
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        self.layer.cornerRadius = type.cornerRadius
        
        switch type {
        case .favorite:
            self.addTarget(self,
                           action: #selector(favoriteButtonTapped),
                           for: .touchUpInside)
        case .foot:
            self.addTarget(self,
                           action: #selector(visitButtonTapped),
                           for: .touchUpInside)
        }
    }
    
    @objc
    private func favoriteButtonTapped() {
        print(#function)
        self.isUserInteractionEnabled = false
        self.isSelected.toggle()
        guard let restaurantInfo else { return }
        if let restaurantInfo = repo.getItemById(id: restaurantInfo.storeID) {
            // 이미 테이블이 존재하는 경우 업데이트
            repo.createAndEditItem(checkTable: true, data: restaurantInfo, isVisited: nil, isFavorite: self.isSelected, rating: nil, review: nil) { isSuccess in
                if isSuccess {
                    print("즐겨찾기 \(self.isSelected ? "추가" : "해제") 성공")
                    
                    // 모든 값이 false 또는 nil인 경우 데이터 삭제
                    if !self.isSelected && !(restaurantInfo.isVisited) && restaurantInfo.rating == nil && restaurantInfo.review == nil {
                        self.repo.deleteItemInUpdate(data: restaurantInfo)
                    }
                } else {
                    print("즐겨찾기 \(self.isSelected ? "추가" : "해제") 실패")
                    self.isSelected.toggle() // 실패 시 상태 되돌리기
                }
            }
        } else {
            guard let restaurant = self.restaurantInfo else {
                self.isSelected.toggle() // 실패 시 상태 되돌리기
                self.isUserInteractionEnabled = true
                return
            }
            
            // 새 RestaurantTable 객체 생성
            let newTable = createNewRestaurantTable(from: restaurant, isFavorite: true)
            
            // 데이터베이스에 저장
            repo.createAndEditItem(checkTable: false, data: newTable, isVisited: nil, isFavorite: true, rating: nil, review: nil) { isSuccess in
                if isSuccess {
                    print("새 즐겨찾기 추가 성공")
                } else {
                    print("새 즐겨찾기 추가 실패")
                    self.isSelected.toggle() // 실패 시 상태 되돌리기
                }
            }
        }
        
        self.isUserInteractionEnabled = true
        onChangeState?()
    }
    
    @objc
    private func visitButtonTapped() {
        print(#function)
        self.isUserInteractionEnabled = false
        self.isSelected.toggle()
        guard let restaurantInfo else { return }
        if let restaurantInfo = repo.getItemById(id: restaurantInfo.storeID) {
            // 이미 테이블이 존재하는 경우 업데이트
            repo.createAndEditItem(checkTable: true, data: restaurantInfo, isVisited: self.isSelected, isFavorite: nil, rating: nil, review: nil) { isSuccess in
                if isSuccess {
                    print("방문 기록 \(self.isSelected ? "추가" : "해제") 성공")
                    
                    // 모든 값이 false 또는 nil인 경우 데이터 삭제
                    if !self.isSelected && !(restaurantInfo.isFavorite) && restaurantInfo.rating == nil && restaurantInfo.review == nil {
                        self.repo.deleteItemInUpdate(data: restaurantInfo)
                    }
                } else {
                    print("방문 기록 \(self.isSelected ? "추가" : "해제") 실패")
                    self.isSelected.toggle() // 실패 시 상태 되돌리기
                }
            }
        } else {
            // Restaurant 객체를 RestaurantTable로 변환하여 신규 생성해야 함
            guard let restaurant = self.restaurantInfo else {
                self.isSelected.toggle() // 실패 시 상태 되돌리기
                self.isUserInteractionEnabled = true
                return
            }
            
            // 새 RestaurantTable 객체 생성
            let newTable = createNewRestaurantTable(from: restaurant, isVisited: true)
            
            // 데이터베이스에 저장
            repo.createAndEditItem(checkTable: false, data: newTable, isVisited: true, isFavorite: nil, rating: nil, review: nil) { isSuccess in
                if isSuccess {
                    print("새 방문 기록 추가 성공")
                } else {
                    print("새 방문 기록 추가 실패")
                    self.isSelected.toggle() // 실패 시 상태 되돌리기
                }
            }
        }
        
        self.isUserInteractionEnabled = true
        onChangeState?()
    }
    
    // Restaurant 객체로부터 새 RestaurantTable 생성
    private func createNewRestaurantTable(from restaurant: Restaurant, isVisited: Bool = false, isFavorite: Bool = false) -> RestaurantTable {
        print(#function)
        let emptyList = List<String>()
        restaurant.menus.forEach { emptyList.append($0) }
        
        return RestaurantTable(
            storeID: restaurant.storeID,
            youtubeId: restaurant.youtubeId,
            name: restaurant.name,
            category: restaurant.category,
            number: restaurant.number,
            openingHours: restaurant.openingHours,
            address: restaurant.address,
            latitude: restaurant.latitude,
            longitude: restaurant.longitude,
            menus: emptyList,
            closedDays: restaurant.closedDays,
            amenities: restaurant.amenities,
            isVisited: isVisited,
            isFavorite: isFavorite,
            rating: nil,
            review: nil
        )
    }
    
    // 레스토랑 정보 설정 - 상세 페이지에서 호출
    func configureWithRestaurant(restaurant: Restaurant) {
        self.restaurantInfo = restaurant
        
        if let store = repo.getItemById(id: restaurant.storeID) {
            switch type {
            case .favorite:
                self.isSelected = store.isFavorite
            case .foot:
                self.isSelected = store.isVisited
            }
        } else {
            self.isSelected = false
        }
    }
    
}

