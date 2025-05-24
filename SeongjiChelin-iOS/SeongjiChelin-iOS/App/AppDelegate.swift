//
//  AppDelegate.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

import RealmSwift
import GooglePlaces
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey(Config.googleAPIKey)
        GMSServices.provideAPIKey(Config.googleAPIKey)
        
        migration()
        
        // 현재 사용자가 쓰고 있는 DB의 Schema Version 체크
        let realm = try! Realm()
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("현재 Schema Version: \(version)")
        } catch {
            print("Schema Version 확인 실패: \(error)")
        }
        
        return true
    }
    
    func migration() {
        let config = Realm.Configuration(schemaVersion: 1) {
            migration, oldSchemaVersion in
            
            // schemaVersion 0 -> 1:
            // RestaurantTable에 hasRating, createdAt, updatedAt 추가 + RestaurantBridge 테이블 추가
            if oldSchemaVersion < 1 {
                print("Schema 0 -> 1 마이그레이션 시작")
                
                migration.enumerateObjects(ofType: RestaurantTable.className()) { oldObject, newObject in
                    guard let oldObject,
                          let newObject else { return }
                    
                    // hasRating 필드 추가: 기존 rating이 있으면 true, 없으면 false
                    if let rating = oldObject["rating"] as? Double? {
                        newObject["hasRating"] = (rating != nil)
                    } else {
                        newObject["hasRating"] = false
                    }
                    
                    // createdAt, updatedAt 필드 추가: 현재 시간으로 설정
                    let now = Date()
                    newObject["createdAt"] = now
                    newObject["updatedAt"] = now
                    
                    // restaurantBridge는 초기화 시점에서 별도로 설정됨 (nil로 시작)
                    newObject["restaurantBridge"] = nil
                    
                    print("RestaurantTable 마이그레이션: storeID \(oldObject["storeID"] ?? "unknown")")
                }
                
                print("Schema 0 -> 1 마이그레이션 완료")
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
        print("Realm 마이그레이션 설정 완료")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

