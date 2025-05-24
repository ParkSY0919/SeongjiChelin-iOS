//
//  SceneDelegate.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 3/28/25.
//

import UIKit

import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // 메인 화면 설정 이전 브릿지 초기화
        initializeAppData()
        
        // AppCoordinator 초기화 및 시작
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
        
        appCoordinator = AppCoordinator(navigationController: navController, window: window!)
        appCoordinator?.start()
    }
    
    private func initializeAppData() {
        let repository = RestaurantRepository()
        repository.initializeRestaurantBridges()
        print("앱 데이터 초기화 완료")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

