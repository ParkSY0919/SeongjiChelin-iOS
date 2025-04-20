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
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func setStyle() {
        titleLabel.setLabelUI(
            "",
            font: .seongiFont(.body_black_14),
            textColor: .primary200.withAlphaComponent(0.6)
        )
    }
    
    func configureMenuCell(title: String) {
        titleLabel.text = title
    }
    
}
