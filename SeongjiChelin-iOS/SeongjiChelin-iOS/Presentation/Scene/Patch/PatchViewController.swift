//
//  PatchViewController.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

protocol PatchViewControllerDelegate: AnyObject {
    func patchDidComplete()
}

final class PatchViewController: BaseViewController {

    // MARK: - Properties

    weak var delegate: PatchViewControllerDelegate?

    private let viewModel: PatchViewModel
    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let logoImageView = UIImageView()
    private let statusLabel = UILabel()
    private let progressContainerView = UIView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let progressLabel = UILabel()

    // MARK: - Init

    init(viewModel: PatchViewModel = PatchViewModel()) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    // MARK: - Setup

    override func setHierarchy() {
        view.addSubview(logoImageView)
        view.addSubview(statusLabel)
        view.addSubview(progressContainerView)
        progressContainerView.addSubview(progressView)
        progressContainerView.addSubview(progressLabel)
    }

    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-80)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        progressContainerView.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }

        progressView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }

        progressLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }

    override func setStyle() {
        view.backgroundColor = .bg100

        logoImageView.do {
            $0.image = ImageLiterals.horizentalLogo
            $0.contentMode = .scaleAspectFit
        }

        statusLabel.do {
            $0.text = StringLiterals.shared.checkingForUpdates
            $0.font = .seongiFont(.title_bold_16)
            $0.textColor = .primary200
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }

        progressContainerView.do {
            $0.isHidden = true
        }

        progressView.do {
            $0.progressTintColor = .primary200
            $0.trackTintColor = .bg300
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }

        progressLabel.do {
            $0.text = "0%"
            $0.font = .seongiFont(.body_med_14)
            $0.textColor = .primary100
            $0.textAlignment = .center
        }
    }

    // MARK: - Binding

    private func bind() {
        let input = PatchViewModel.Input(
            viewDidLoad: Observable.just(())
        )

        let output = viewModel.transform(input: input)

        // 상태 텍스트 바인딩
        output.statusText
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)

        // 패치 상태에 따른 UI 업데이트
        output.patchState
            .drive(onNext: { [weak self] state in
                self?.updateUI(for: state)
            })
            .disposed(by: disposeBag)

        // 진행률 바인딩
        output.progress
            .drive(onNext: { [weak self] progress in
                self?.progressView.setProgress(progress, animated: true)
                self?.progressLabel.text = "\(Int(progress * 100))%"
            })
            .disposed(by: disposeBag)

        // 홈으로 이동
        output.shouldNavigateToHome
            .emit(onNext: { [weak self] in
                self?.delegate?.patchDidComplete()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UI Updates

    private func updateUI(for state: PatchState) {
        switch state {
        case .idle:
            progressContainerView.isHidden = true

        case .checking:
            progressContainerView.isHidden = true

        case .downloading:
            progressContainerView.isHidden = false

        case .completed:
            progressContainerView.isHidden = false
            progressView.setProgress(1.0, animated: true)
            progressLabel.text = "100%"
            animateCompletion()

        case .upToDate:
            progressContainerView.isHidden = true
            animateUpToDate()

        case .failed:
            progressContainerView.isHidden = true
            animateFailed()
        }
    }

    private func animateCompletion() {
        UIView.animate(withDuration: 0.3) {
            self.statusLabel.textColor = .영업중
        }
    }

    private func animateUpToDate() {
        UIView.animate(withDuration: 0.3) {
            self.statusLabel.textColor = .primary200
        }
    }

    private func animateFailed() {
        UIView.animate(withDuration: 0.3) {
            self.statusLabel.textColor = .영업종료
        }
    }
}
