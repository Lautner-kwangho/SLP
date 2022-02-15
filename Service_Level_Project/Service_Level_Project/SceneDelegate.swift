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

//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//      for urlContext in URLContexts {
//          let url = urlContext.url
//          Auth.auth().canHandle(url)
//      }
//      // URL not auth related, developer should handle it.
//    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
//         임시로 작업하려고 옮겨 놓음
        window?.rootViewController = UINavigationController(rootViewController: ChattingViewController())
//         여기에 작업
        
        let idToken = UserDefaults.standard.string(forKey: UserDefaultsManager.authIdToken)
//
//        if idToken == nil {
//            window?.rootViewController = UINavigationController(rootViewController: AuthPhoneViewController())
//        } else {
//            SeSacURLNetwork.shared.loginMember { data in
//                windowScene.windows.first?.rootViewController = BaseTabBarViewController()//MyInfoViewController
//            } failErrror: { error in
//                windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: CreateNicknameViewController())
//            }
//        }
        window?.makeKeyAndVisible()
        
        //Keyboard
        IQKeyboardManager.shared.enable = true
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        // Firebase FCM token
        
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
                // 앱 지우고 다시 설치하니까 이런 오류 뜸(체크하기) -> 근데 두번째 빌드에서는 받아옴;
                // Failed to checkin before token registration.
            } else if let token = token {
//                print("FCM registration token: \(token)")
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

