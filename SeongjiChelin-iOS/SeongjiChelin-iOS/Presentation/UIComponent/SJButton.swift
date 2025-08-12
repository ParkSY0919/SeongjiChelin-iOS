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
//        repo.getFileURL()
        setFavoriteButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFavoriteButtonStyle() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.background.backgroundColor = .primary100
        buttonConfiguration.baseForegroundColor = .bg100
        buttonConfiguration.background.cornerRadius = type.cornerRadius
        self.configuration = buttonConfiguration
        
        let footImage = ImageLiterals.foot.resized(to: CGSize(width: 26, height: 26))
        let footFillImage = ImageLiterals.footFill.withRenderingMode(.alwaysTemplate).resized(to: CGSize(width: 26, height: 26))
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                switch self.type {
                case .favorite:
                    button.configuration?.image = ImageLiterals.bookmark
                case .foot:
                    button.configuration?.image = footImage
                }
            case .selected:
                switch self.type {
                case .favorite:
                    button.configuration?.image = ImageLiterals.bookmarkFill
                case .foot:
                    button.configuration?.image = footFillImage
                }
            default:
                return
            }
        }
        self.configurationUpdateHandler = buttonStateHandler
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        
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
                print(!self.isSelected ? StringLiterals.shared.favRemoveSuccess : StringLiterals.shared.favAddSuccess)
            case false:
                print(!self.isSelected ? StringLiterals.shared.favRemoveFailed : StringLiterals.shared.favAddFailed)
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
                print(!self.isSelected ? "방문 해제 성공" : "방문 추가 성공")
            case false:
                print(!self.isSelected ? "방문 해제 실패" : "방문 추가 실패")
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

