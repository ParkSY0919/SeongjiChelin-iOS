//
//  DetailViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/6/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxCombine
import SnapKit
import Then
import YouTubePlayerKit

@available(iOS 16.0, *)
final class DetailViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    private let youtubePlayer: YouTubePlayer
    private lazy var playerViewController = YouTubePlayerViewController(player: self.youtubePlayer)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.youtubePlayer = YouTubePlayer(source: viewModel.videoSource, configuration: .init(fullscreenMode: .system))
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accentBeige
        setupUIElements()
        setupYouTubePlayerView()
        bindPlayerState()
    }
    
    private func setupUIElements() {
        loadingIndicator.hidesWhenStopped = true // 멈추면 자동으로 숨김
        loadingIndicator.color = .white
        view.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(20 + (view.bounds.width - 40) * (9.0/16.0) / 2)
        }
    }
    
    private func setupYouTubePlayerView() {
        addChild(playerViewController)
        view.addSubview(playerViewController.view)
        // 플레이어 뷰를 로딩 인디케이터/에러 레이블 뒤로 보내기
//        view.sendSubviewToBack(playerViewController.view)
        playerViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(playerViewController.view.snp.width).multipliedBy(9.0/16.0)
        }
        playerViewController.didMove(toParent: self)
    }
    
    private func bindPlayerState() {
        let stateObservable: Observable<YouTubePlayer.State> = youtubePlayer.statePublisher.asObservable()
        
        stateObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                print("Player state changed (Rx): \(state)")
                switch state {
                case .idle:
                    print("로딩 중")
                    self.loadingIndicator.startAnimating()
                    self.playerViewController.view.isHidden = true
                    
                case .ready:
                    print("준비 완료")
                    self.loadingIndicator.stopAnimating()
                    self.playerViewController.view.isHidden = false
                case .error(let error):
                    print("Player error (Rx): \(error)")
                    self.loadingIndicator.stopAnimating()
                    self.playerViewController.view.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        // 재생 시간 관찰 등 (이전과 동일)
        youtubePlayer.currentTimePublisher.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { currentTime in
                // print("Current Time: \(currentTime ?? 0.0)")
            })
            .disposed(by: disposeBag)
    }
    
    
    
    func setSheet() {
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
