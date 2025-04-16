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
    private let repo: RestaurantRepositoryProtocol
    private var restaurantInfo: Restaurant?
    var onChangeState: (() -> ())?
    
    init(type: SJButtonType, repo: RestaurantRepositoryProtocol) {
        self.type = type
        self.repo = repo
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
        repo.upsertRestaurant(
            storeID: restaurantInfo.storeID,
            isVisited: nil,
            isFavorite: self.isSelected,
            rating: nil,
            review: nil
        ) { isSuccess in
            switch isSuccess {
            case true:
                print("즐겨찾기 \(self.isSelected ? "추가" : "해제") 성공")
            case false:
                print("즐겨찾기 \(self.isSelected ? "추가" : "해제") 실패")
                self.isSelected.toggle() //실패 시 상태 되돌리기
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
        repo.upsertRestaurant(
            storeID: restaurantInfo.storeID,
            isVisited: self.isSelected,
            isFavorite: nil,
            rating: nil,
            review: nil
        ) { isSuccess in
            switch isSuccess {
            case true:
                print("즐겨찾기 \(self.isSelected ? "추가" : "해제") 성공")
            case false:
                print("즐겨찾기 \(self.isSelected ? "추가" : "해제") 실패")
                self.isSelected.toggle() //실패 시 상태 되돌리기
            }
        }
        self.isUserInteractionEnabled = true
        onChangeState?()
    }
    
    // 레스토랑 정보 설정 - 상세 페이지에서 호출
    func configureWithRestaurant(restaurant: Restaurant) {
        self.restaurantInfo = restaurant
        
        if let store = repo.getTableByStoreID(storeID: restaurant.storeID) {
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

