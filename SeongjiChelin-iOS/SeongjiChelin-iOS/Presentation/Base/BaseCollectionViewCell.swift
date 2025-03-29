//
//  BaseCollectionViewCell.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/29/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReusableViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {}
    
    func setLayout() {}
    
    func setStyle() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
