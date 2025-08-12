//
//  AppUpdateChecker.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/25/25.
//

import UIKit

final class AppUpdateChecker {
    
    static let shared = AppUpdateChecker()
    
    private init() {}
    
    func checkForUpdate(completion: @escaping (Bool) -> Void) {
        //현재 앱 버전 가져오기
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            completion(false)
            return
        }
        
        //App Store에서 앱 정보 가져오기
        let appID = Config.appID
        let appStoreURL = "https://itunes.apple.com/lookup?bundleId=\(appID)"
        
        guard let url = URL(string: appStoreURL) else {
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {
                    
                    //버전 비교
                    DispatchQueue.main.async {
                        let needsUpdate = self.compareVersions(currentVersion: currentVersion,
                                                               appStoreVersion: appStoreVersion,
                                                               forceUpdate: false)
                        completion(needsUpdate)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("Error parsing App Store data: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }.resume()
    }
    
    
    private func compareVersions(currentVersion: String, appStoreVersion: String, forceUpdate: Bool) -> Bool {
        let current = currentVersion.components(separatedBy: ".").compactMap { Int($0) }
        let appStore = appStoreVersion.components(separatedBy: ".").compactMap { Int($0) }
        
        //간단한 버전 비교
        var needsUpdate = false
        
        for i in 0..<min(current.count, appStore.count) {
            if appStore[i] > current[i] {
                needsUpdate = true
                break
            } else if appStore[i] < current[i] {
                break
            }
        }
        
        if needsUpdate || (forceUpdate && appStoreVersion != currentVersion) {
            self.showUpdateAlert(appStoreVersion: appStoreVersion, forceUpdate: forceUpdate)
            return true
        }
        
        return false
    }
    
    private func showUpdateAlert(appStoreVersion: String, forceUpdate: Bool) {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? StringLiterals.shared.app
        
        let alertController = UIAlertController(
            title: "\(appName) \(StringLiterals.shared.update)",
            message: "새로운 버전 \(appStoreVersion)이 출시되었습니다.",
            preferredStyle: .alert
        )
        
        //업데이트 버튼
        let updateAction = UIAlertAction(title: StringLiterals.shared.update, style: .default) { _ in
            let appStoreID = Config.appID
            
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appStoreID)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                //강제 업데이트인 경우 앱 종료
                if forceUpdate {
                    exit(0)
                }
            }
        }
        
        alertController.addAction(updateAction)
        
        //강제 업데이트가 아닌 경우 나중에 버튼 추가
        if !forceUpdate {
            let laterAction = UIAlertAction(title: StringLiterals.shared.later, style: .cancel, handler: nil)
            alertController.addAction(laterAction)
        }
        
        //최상위 뷰컨트롤러에 알림창 표시
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            var topController = rootViewController
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
}
