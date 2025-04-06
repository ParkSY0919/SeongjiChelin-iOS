//
//  DetailViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

@available(iOS 16.0, *)
final class DetailViewController: BaseViewController {
    
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setSheet()
        view.backgroundColor = .accentBeige
    }
    
    private func setSheet() {
        if let sheet = self.sheetPresentationController {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .customSmall) { context in
                return context.maximumDetentValue * 0.45
            }
            sheet.largestUndimmedDetentIdentifier = .customSmall
            
            sheet.detents = [smallDetent, .large()]
            sheet.delegate = self
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .customSmall
        }
    }
    
}

@available(iOS 16.0, *)
extension DetailViewController: UISheetPresentationControllerDelegate {
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        // sheet 크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .customSmall ? "customSmall" : "large")
        
    }
    
}

extension UISheetPresentationController.Detent.Identifier {
    
    static let customSmall = UISheetPresentationController.Detent.Identifier("customSmall")
    
}
