//
//  SJRatingView.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/12/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SJRatingView: UIView {
    
    // MARK: - Properties
    
    private let repo: RestaurantRepositoryProtocol = RestaurantRepository()
    private var restaurantInfo: RestaurantTable?
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let ratingView = UIStackView()
    private let starButtons: [UIButton] = (1...5).map { _ in
        return UIButton().then {
            $0.setImage(ImageLiterals.star, for: .normal)
            $0.setImage(ImageLiterals.starFill, for: .selected)
            $0.tintColor = .accentPink
        }
    }
    private let ratingLabel = UILabel()
    private let reviewTextView = UITextView()
    private let saveButton = UIButton()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    private func setHierarchy() {
        addSubviews(
            titleLabel,
            ratingView,
            ratingLabel,
            reviewTextView,
            saveButton
        )
        
        starButtons.forEach { ratingView.addArrangedSubview($0) }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        ratingView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(ratingView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        reviewTextView.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(reviewTextView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setStyle() {
        backgroundColor = .bg100
        layer.cornerRadius = 16
        
        titleLabel.do {
            $0.text = "이 식당은 어떠셨나요?"
            $0.font = .seongiFont(.title_bold_16)
            $0.textColor = .text100
        }
        
        ratingView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        ratingLabel.do {
            $0.text = "0.0/5.0"
            $0.font = .seongiFont(.body_regular_14)
            $0.textColor = .accentPink
        }
        
        reviewTextView.do {
            $0.backgroundColor = .bg200
            $0.layer.cornerRadius = 8
            $0.font = .seongiFont(.body_regular_14)
            $0.textColor = .text100
            $0.text = "리뷰를 작성해주세요 (선택사항)"
            $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
        
        saveButton.do {
            $0.setTitle("저장하기", for: .normal)
            $0.setTitleColor(.bg100, for: .normal)
            $0.backgroundColor = .primary100
            $0.layer.cornerRadius = 8
        }
    }
    
    // MARK: - Bindings
    
    private func setUpBindings() {
        // 별점 버튼 탭 이벤트 처리
        for (index, button) in starButtons.enumerated() {
            button.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateRating(rating: Double(index + 1))
                })
                .disposed(by: disposeBag)
        }
        
        // 저장 버튼 탭 이벤트 처리
        saveButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let restaurant = self.restaurantInfo else { return }
                
                let currentRating = Double(self.starButtons.filter { $0.isSelected }.count)
                let reviewText = self.reviewTextView.text == "리뷰를 작성해주세요 (선택사항)" ? nil : self.reviewTextView.text
                
                // 리뷰 및 평점 저장
                
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    func configure(with restaurant: RestaurantTable) {
        self.restaurantInfo = restaurant
        
        // 기존 평점이 있는 경우 UI 업데이트
        if let rating = restaurant.rating {
            updateRating(rating: rating)
        }
        
        // 기존 리뷰가 있는 경우 UI 업데이트
        if let review = restaurant.review {
            reviewTextView.text = review
            reviewTextView.textColor = .text100
        }
    }
    
    // MARK: - Private Methods
    
    private func updateRating(rating: Double) {
        // 별점 UI 업데이트
        for i in 0..<starButtons.count {
            starButtons[i].isSelected = Double(i + 1) <= rating
        }
        
        // 별점 텍스트 업데이트
        ratingLabel.text = String(format: "%.1f/5.0", rating)
    }
} 
