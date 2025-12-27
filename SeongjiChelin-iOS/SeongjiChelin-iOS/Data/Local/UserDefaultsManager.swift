//
//  UserDefaultsManager.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation

/// UserDefaults 기반 앱 설정 및 패치 정보 관리
final class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private let defaults = UserDefaults.standard

    private init() {}

    // MARK: - Keys

    private enum Keys {
        static let cachedVersion = "cachedRestaurantVersion"
        static let lastPatchDate = "lastRestaurantPatchDate"
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

    // MARK: - Restaurant Data Patch

    /// 캐시된 식당 데이터 버전
    var cachedVersion: String? {
        get { defaults.string(forKey: Keys.cachedVersion) }
        set { defaults.set(newValue, forKey: Keys.cachedVersion) }
    }

    /// 마지막 패치 날짜
    var lastPatchDate: Date? {
        get { defaults.object(forKey: Keys.lastPatchDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastPatchDate) }
    }

    /// 오늘 패치를 이미 수행했는지 확인
    var hasPatchedToday: Bool {
        guard let lastPatch = lastPatchDate else { return false }
        return Calendar.current.isDateInToday(lastPatch)
    }

    /// 패치가 필요한지 확인 (오늘 패치 안 했으면 필요)
    var needsPatchToday: Bool {
        return !hasPatchedToday
    }

    /// 패치 완료 기록
    func recordPatchCompletion(version: String) {
        cachedVersion = version
        lastPatchDate = Date()
    }

    /// 패치 정보 초기화 (디버그/테스트용)
    func resetPatchInfo() {
        cachedVersion = nil
        lastPatchDate = nil
    }

    // MARK: - Onboarding

    /// 온보딩을 본 적 있는지
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasSeenOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasSeenOnboarding) }
    }

    // MARK: - Version Comparison

    /// 버전 비교 (semantic versioning)
    /// - Returns: true if remote version is newer
    func isNewerVersion(remote: String, than local: String?) -> Bool {
        guard let local = local else { return true }

        let remoteComponents = remote.split(separator: ".").compactMap { Int($0) }
        let localComponents = local.split(separator: ".").compactMap { Int($0) }

        let maxLength = max(remoteComponents.count, localComponents.count)

        for i in 0..<maxLength {
            let remoteValue = i < remoteComponents.count ? remoteComponents[i] : 0
            let localValue = i < localComponents.count ? localComponents[i] : 0

            if remoteValue > localValue {
                return true
            } else if remoteValue < localValue {
                return false
            }
        }

        return false // 같은 버전
    }
}
