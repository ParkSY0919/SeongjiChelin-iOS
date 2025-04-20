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

    private var isScaledUp = false
    private let animationDuration: TimeInterval = 0.2
    private let scaleFactor: CGFloat = 1.3

    init(themeType: RestaurantThemeType) {
        self.themeType = themeType
        
        let defaultFrame = CGRect(x: 0, y: 0, width: 32, height: 32)
        super.init(frame: defaultFrame)

        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        iconImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.tintColor = .bg100
            $0.image = themeType.madeImage
        }

        self.do {
            $0.backgroundColor = themeType.color
            $0.layer.cornerRadius = 32 / 2
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.bg100.cgColor
             $0.layer.shadowColor = UIColor.black.cgColor
             $0.layer.shadowOffset = CGSize(width: 0, height: 1)
             $0.layer.shadowRadius = 2
             $0.layer.shadowOpacity = 0.3
        }

        addSubview(iconImageView)
    }

    private func setupLayout() {
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(self.snp.size).inset(8)
        }

        self.snp.makeConstraints {
            $0.size.equalTo(32)
        }
    }

    ///마커뷰 확대
    func scaleUp() {
        guard !isScaledUp else { return }
        isScaledUp = true

        UIView.animate(withDuration: animationDuration, animations: {
            self.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
        })
//        self.layer.zPosition = 1
    }

    ///마커 뷰 크기 원위치
    func resetScale() {
        guard isScaledUp else { return }
        isScaledUp = false

        UIView.animate(withDuration: animationDuration, animations: {
            self.transform = .identity
        })
//        self.layer.zPosition = 0
    }
    
}
