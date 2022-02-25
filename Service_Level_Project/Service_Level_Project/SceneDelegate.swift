//
//  SceneDelegate.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate, MessagingDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
        let idToken = UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)
        let onboarding = UserDefaults.standard.bool(forKey: UserDefaultsManager.onboarding)
        
        if idToken == nil {
            if onboarding {
                window?.rootViewController = UINavigationController(rootViewController: AuthPhoneViewController())
            } else {
                window?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
            }
        } else {
            SeSacURLNetwork.shared.loginMember { data in
                windowScene.windows.first?.rootViewController = BaseTabBarViewController()
            } failErrror: { error in
                windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: CreateNicknameViewController())
            }
        }
        window?.makeKeyAndVisible()
        
        //Keyboard
        IQKeyboardManager.shared.enable = true
        
        // Firebase FCM token
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
                // 앱 지우고 다시 설치하니까 이런 오류 뜸(체크하기) -> 근데 두번째 빌드에서는 받아옴;
                // Failed to checkin before token registration.
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaults.standard.set(token, forKey: "fcmToken")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 알림 삭제해주기
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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

