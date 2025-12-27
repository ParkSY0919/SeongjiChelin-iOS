//
//  DataPatchManager.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation
import RxSwift
import RxCocoa

/// 패치 상태
enum PatchState: Equatable {
    case idle
    case checking
    case downloading(progress: Float)
    case completed
    case failed(message: String)
    case upToDate

    static func == (lhs: PatchState, rhs: PatchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.checking, .checking),
             (.completed, .completed),
             (.upToDate, .upToDate):
            return true
        case (.downloading(let p1), .downloading(let p2)):
            return p1 == p2
        case (.failed(let m1), .failed(let m2)):
            return m1 == m2
        default:
            return false
        }
    }

    var displayText: String {
        switch self {
        case .idle:
            return ""
        case .checking:
            return StringLiterals.shared.checkingForUpdates
        case .downloading:
            return StringLiterals.shared.downloadingData
        case .completed:
            return StringLiterals.shared.updateComplete
        case .failed:
            return StringLiterals.shared.updateFailed
        case .upToDate:
            return StringLiterals.shared.alreadyUpToDate
        }
    }

    var isTerminal: Bool {
        switch self {
        case .completed, .failed, .upToDate:
            return true
        default:
            return false
        }
    }
}

/// 데이터 패치 관리자
final class DataPatchManager {

    static let shared = DataPatchManager()

    private let repository: RestaurantDataRepository
    private let disposeBag = DisposeBag()

    // Observable State
    let patchState = BehaviorRelay<PatchState>(value: .idle)
    let progressSubject = PublishSubject<Float>()

    // Completion handler
    private var completionHandler: (() -> Void)?

    private init(repository: RestaurantDataRepository = .shared) {
        self.repository = repository
    }

    // MARK: - Public Methods

    /// 오늘 패치가 필요한지 확인 (00시 기준)
    func shouldPatchToday() -> Bool {
        return repository.shouldPatchToday()
    }

    /// 패치 실행
    func executePatch(completion: (() -> Void)? = nil) {
        self.completionHandler = completion
        patchState.accept(.checking)

        repository.checkForUpdates()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    self?.handleVersionCheckResult(result)
                },
                onError: { [weak self] error in
                    print("[PatchManager] 버전 체크 오류: \(error)")
                    // 오류 시 오프라인 모드로 진행
                    self?.handleOfflineMode()
                }
            )
            .disposed(by: disposeBag)
    }

    /// 강제 패치 실행 (버전 체크 무시)
    func forceExecutePatch(completion: (() -> Void)? = nil) {
        self.completionHandler = completion
        startDownload()
    }

    // MARK: - Private Methods

    private func handleVersionCheckResult(_ result: VersionCheckResult) {
        print("[PatchManager] 버전 체크 결과 - 현재: \(result.currentVersion ?? "없음"), 최신: \(result.latestVersion), 업데이트 필요: \(result.needsUpdate)")

        if result.needsUpdate {
            startDownload()
        } else {
            patchState.accept(.upToDate)
            scheduleCompletion()
        }
    }

    private func startDownload() {
        patchState.accept(.downloading(progress: 0))

        // 진행률 관찰
        progressSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                self?.patchState.accept(.downloading(progress: progress))
            })
            .disposed(by: disposeBag)

        repository.downloadLatestData(progress: progressSubject)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] success in
                    if success {
                        self?.patchState.accept(.completed)
                    } else {
                        self?.patchState.accept(.failed(message: StringLiterals.shared.downloadFailed))
                    }
                    self?.scheduleCompletion()
                },
                onError: { [weak self] error in
                    print("[PatchManager] 다운로드 오류: \(error)")
                    self?.patchState.accept(.failed(message: error.localizedDescription))
                    self?.scheduleCompletion()
                }
            )
            .disposed(by: disposeBag)
    }

    private func handleOfflineMode() {
        // 네트워크 오류 시 기존 캐시 데이터 사용
        print("[PatchManager] 오프라인 모드로 전환")
        patchState.accept(.upToDate)
        scheduleCompletion()
    }

    private func scheduleCompletion() {
        // 상태 표시 후 1.5초 대기 후 완료 콜백 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.completionHandler?()
            self?.completionHandler = nil
        }
    }

    // MARK: - Reset

    /// 상태 초기화
    func reset() {
        patchState.accept(.idle)
    }
}
