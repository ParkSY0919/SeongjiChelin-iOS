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

final class DetailViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    private let youtubePlayer: YouTubePlayer
    
    private let favoriteButton = SJFavoriteButton()
    private let storeNameLabel = UILabel()
    private let storeAddressLabel = UILabel()
    private let storeInfoLabel = UILabel()
    private let inMenuLabel = UILabel()
    private let nearWeatherLabel = UILabel()
    private let nearWeatherImageView = UIImageView()
    private let youtubePlayerContainer = UIView()
    
    private lazy var playerViewController = YouTubePlayerViewController(player: self.youtubePlayer)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.youtubePlayer = YouTubePlayer(source: viewModel.videoSource, configuration: .init(fullscreenMode: .system))
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accentBeige
        configureDetailView(restaurant: viewModel.restaurantInfo)
        bindPlayerState()
    }
    
    override func setHierarchy() {
        view.addSubviews(
            favoriteButton,
            storeNameLabel,
            storeAddressLabel,
            storeInfoLabel,
            inMenuLabel,
            nearWeatherLabel,
            nearWeatherImageView,
            youtubePlayerContainer
        )
        
        addChild(playerViewController)
        
        youtubePlayerContainer.addSubviews(loadingIndicator, playerViewController.view)
    }
    
    override func setLayout() {
        
        storeNameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalTo(storeNameLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(36)
        }
        
        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        storeInfoLabel.snp.makeConstraints {
            $0.top.equalTo(storeAddressLabel.snp.bottom).offset(12)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        inMenuLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfoLabel.snp.bottom).offset(12)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        nearWeatherLabel.snp.makeConstraints {
            $0.top.equalTo(inMenuLabel.snp.bottom).offset(12)
            $0.leading.equalTo(storeNameLabel.snp.leading)
        }
        
        youtubePlayerContainer.snp.makeConstraints {
            $0.top.equalTo(nearWeatherLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(youtubePlayerContainer.snp.width).multipliedBy(9.0/16.0)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        playerViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playerViewController.didMove(toParent: self)
    }
    
    override func setStyle() {
        storeNameLabel.setLabelUI("", font: .seongiFont(.title_bold_20), textColor: .primary200)
        storeAddressLabel.setLabelUI("", font: .seongiFont(.body_bold_12), textColor: .text100)
        storeInfoLabel.setLabelUI("", font: .seongiFont(.body_bold_12), textColor: .text100)
        inMenuLabel.setLabelUI("", font: .seongiFont(.body_bold_12), textColor: .text100)
        nearWeatherLabel.setLabelUI("", font: .seongiFont(.body_bold_12), textColor: .text100)
        
        nearWeatherImageView.do {
            $0.image = UIImage(systemName: "star")
            $0.contentMode = .scaleAspectFill
            $0.tintColor = .accentPink
        }
        
        youtubePlayerContainer.do {
            print("current: \(viewModel.restaurantInfo.youtubeId == nil)")
            $0.isHidden = viewModel.restaurantInfo.youtubeId == nil
            $0.backgroundColor = .bg200
        }
        
        loadingIndicator.do {
            $0.hidesWhenStopped = true // 멈추면 자동으로 숨김
            $0.color = .primary300
        }
    }
    
    //TODO: 추후 각 데이터 바인딩 수정
    private func configureDetailView(restaurant: Restaurant) {
        storeNameLabel.text = restaurant.name
        storeAddressLabel.text = "🧭 주소: " + restaurant.address
        let prefix = "📞 연락처: "
        let contactInfo = restaurant.storeInfo ?? "010-1234-5678"
        let fullText = prefix + contactInfo
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.text100, range: NSRange(location: 0, length: fullText.count))
        let contactRange = NSRange(location: prefix.count + 1, length: contactInfo.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: contactRange)
        storeInfoLabel.attributedText = attributedString
        
        inMenuLabel.text = "📋 영상 속 메뉴: " + (restaurant.inVideoMenus?.map(\.self).joined(separator: ", ") ?? "")
        nearWeatherLabel.text = "🌡️ 현재 근처 날씨: " + "맑음"
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleStoreInfoLabelTap))
        storeInfoLabel.isUserInteractionEnabled = true
        storeInfoLabel.addGestureRecognizer(gesture)
    }
    
    @objc
    private func handleStoreInfoLabelTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        guard let labelText = storeInfoLabel.text else { return }
        
        let prefix = "📞 연락처: "
        if labelText.hasPrefix(prefix) {
            let phoneNumber = String(labelText.dropFirst(prefix.count))
            
            if phoneNumber != "정보 없음" && !phoneNumber.isEmpty {
                makePhoneCall(phoneNumber: phoneNumber)
            } else {
                print("전화번호 정보가 없거나 유효하지 않습니다.")
                let alert = UIAlertManager.shared.showAlert(title: "통화 연결 실패", message: "연락처 정보가 없습니다.")
                present(alert, animated: true)
            }
        }
    }
    
    func makePhoneCall(phoneNumber: String) {
        let cleanedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        guard let phoneUrl = URL(string: "telprompt://\(cleanedPhoneNumber)") else {
            print("🚨 유효하지 않은 전화번호 URL 형식입니다.")
            
            let alert = UIAlertManager.shared.showAlert(title: "통화 연결 실패", message: "전화번호 형식이 올바르지 않습니다.")
            present(alert, animated: true)
            return
        }
        
        if UIApplication.shared.canOpenURL(phoneUrl) {
            UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
        } else {
            print("🚨 전화를 걸 수 없습니다. (기기 또는 번호 문제)")
            let alert = UIAlertManager.shared.showAlert(title: "통화 연결 실패", message: "이 기기에서는 전화를 걸 수 없거나 번호에 문제가 있습니다.")
            present(alert, animated: true)
        }
    }
    
    private func setupYouTubePlayerContainer(isCustomSmall: Bool) {
//        if isCustomSmall {
//            youtubePlayerContainer.snp.remakeConstraints {
//                $0.top.equalTo(nearWeatherLabel.snp.bottom).offset(10)
//                $0.horizontalEdges.equalToSuperview().inset(10)
//                $0.height.equalTo(youtubePlayerContainer.snp.width).multipliedBy(9.0/16.0)
//            }
//        }
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

extension DetailViewController: UISheetPresentationControllerDelegate {
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        // sheet 크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .customSmall ? "customSmall" : "large")
        
//        switch sheetPresentationController.selectedDetentIdentifier != .customSmall {
//        case true:
//            setupYouTubePlayerContainer()
//            self.youtubePlayerContainer.isHidden = false
//        case false:
//            self.youtubePlayerContainer.isHidden = true
//        }
    }
    
}

extension UISheetPresentationController.Detent.Identifier {
    
    static let customSmall = UISheetPresentationController.Detent.Identifier("customSmall")
    
}
