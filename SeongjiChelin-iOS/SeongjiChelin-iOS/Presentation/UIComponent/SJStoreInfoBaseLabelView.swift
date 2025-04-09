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
        case category
        case number
        case time
        case video
        
        var image: UIImage? {
            switch self {
            case .address: UIImage(systemName: "map")
            case .category: UIImage(resource: .riceBowl)
            case .number: UIImage(systemName: "phone")
            case .time: UIImage(systemName: "clock")
            case .video: UIImage(systemName: "video")
            }
        }
        
        var title: String {
            switch self {
            case .address: "주소"
            case .category: "카테고리"
            case .number: "연락처"
            case .time: "영업시간"
            case .video: "영상 속 메뉴"
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
            //TODO: 추후 동적 값으로 수정
            $0.width.equalTo(150)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.height.centerY.equalTo(self.safeAreaLayoutGuide)
            $0.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(6)
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
        titleLabel.text = isValid ? "주인장 추천 메뉴" : type.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
