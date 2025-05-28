//
//  SJStoreInfoBaseLabelView.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/9/25.
//

import UIKit

import SnapKit
import Then

final class SJStoreInfoBaseLabelView: UIView {
    
    enum StoreInfoType {
        case address
        case number
        case parking
        case time
        case video
        
        var image: UIImage? {
            switch self {
            case .address: ImageLiterals.map
            case .number: ImageLiterals.phone
            case .time: ImageLiterals.clock
            case .video: ImageLiterals.video
            case .parking: ImageLiterals.parkingsignSquare
            }
        }
        
        var title: String {
            switch self {
            case .address: "주소"
            case .number: "연락처"
            case .time: "영업 여부"
            case .video: "영상 속 메뉴"
            case .parking: "편의시설"
            }
        }
    }
    
    private let type: StoreInfoType
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let cologneLabel = UILabel()
    
    init(type: StoreInfoType) {
        self.type = type
        
        super.init(frame: .zero)
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    private func setHierarchy() {
        self.addSubviews(
            imageView,
            titleLabel,
            cologneLabel
        )
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(150)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.height.centerY.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(32)
            $0.centerY.equalTo(imageView.snp.centerY)
        }
        
        cologneLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.centerY.equalTo(titleLabel.snp.centerY).offset(-2)
        }
    }
    
    private func setStyle() {
        imageView.do {
            $0.image = type.image
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .accentPink
        }
        
        titleLabel.setLabelUI(
            type.title,
            font: .seongiFont(.body_bold_12),
            textColor: .accentPink
        )
        
        cologneLabel.setLabelUI(
            ":  ",
            font: .seongiFont(.body_bold_14),
            textColor: .accentPink
        )
    }
    
    func isNoYoutube(isValid: Bool) {
        titleLabel.text = isValid ? "추천 메뉴" : type.title
        imageView.image = isValid ? ImageLiterals.handThumbsup : type.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
