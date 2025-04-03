//
//  MenuTableViewCell.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/3/25.
//

import UIKit

import SnapKit

final class MenuTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    
    override func setHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.safeAreaLayoutGuide)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func setStyle() {
        titleLabel.setLabelUI(
            "",
            font: .seongiFont(.body_regular_14),
            textColor: .text100
        )
    }
    
    func configureMenuCell(title: String) {
        
    }
    
}
