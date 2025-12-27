//
//  RestaurantLocalDataSource.swift
//  SeongjiChelin-iOS
//
//  Created by Claude on 12/27/25.
//

import Foundation

/// 로컬 JSON 캐시 관리
final class RestaurantLocalDataSource {

    static let shared = RestaurantLocalDataSource()

    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let fileName = "restaurants_cache.json"

    private init() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cacheDir.appendingPathComponent("RestaurantData")
        createDirectoryIfNeeded()
    }

    private var cacheFileURL: URL {
        cacheDirectory.appendingPathComponent(fileName)
    }

    // MARK: - Public Methods

    /// 캐시된 식당 데이터 로드
    func loadCachedData() -> RemoteRestaurantData? {
        guard fileManager.fileExists(atPath: cacheFileURL.path) else {
            print("[LocalDataSource] 캐시 파일 없음")
            return nil
        }

        do {
            let data = try Data(contentsOf: cacheFileURL)
            let decoder = JSONDecoder()
            let restaurantData = try decoder.decode(RemoteRestaurantData.self, from: data)
            print("[LocalDataSource] 캐시 로드 성공: 버전 \(restaurantData.version)")
            return restaurantData
        } catch {
            print("[LocalDataSource] 캐시 로드 실패: \(error)")
            return nil
        }
    }

    /// 캐시된 테마 목록 로드
    func loadCachedThemes() -> [RestaurantTheme]? {
        guard let data = loadCachedData() else { return nil }
        return data.themes.compactMap { $0.toRestaurantTheme() }
    }

    /// 식당 데이터 저장
    func saveRestaurantData(_ data: RemoteRestaurantData) -> Bool {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: cacheFileURL, options: .atomic)
            print("[LocalDataSource] 캐시 저장 성공: 버전 \(data.version)")
            return true
        } catch {
            print("[LocalDataSource] 캐시 저장 실패: \(error)")
            return false
        }
    }

    /// JSON Data를 직접 저장
    func saveRawData(_ data: Data) -> Bool {
        do {
            try data.write(to: cacheFileURL, options: .atomic)
            print("[LocalDataSource] Raw 데이터 저장 성공")
            return true
        } catch {
            print("[LocalDataSource] Raw 데이터 저장 실패: \(error)")
            return false
        }
    }

    /// 캐시 삭제
    func clearCache() -> Bool {
        guard fileManager.fileExists(atPath: cacheFileURL.path) else { return true }

        do {
            try fileManager.removeItem(at: cacheFileURL)
            print("[LocalDataSource] 캐시 삭제 성공")
            return true
        } catch {
            print("[LocalDataSource] 캐시 삭제 실패: \(error)")
            return false
        }
    }

    /// 캐시 파일 존재 여부
    var hasCachedData: Bool {
        return fileManager.fileExists(atPath: cacheFileURL.path)
    }

    /// 캐시 파일 크기 (bytes)
    var cacheFileSize: Int64? {
        guard let attributes = try? fileManager.attributesOfItem(atPath: cacheFileURL.path) else {
            return nil
        }
        return attributes[.size] as? Int64
    }

    // MARK: - Private Methods

    private func createDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            print("[LocalDataSource] 캐시 디렉토리 생성: \(cacheDirectory.path)")
        }
    }
}
