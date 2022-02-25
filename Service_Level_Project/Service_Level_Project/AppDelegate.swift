//
//  AppDelegate.swift
//  Service_Level_Project
//
//  Created by 최광호 on 2022/01/18.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var rootString: String?
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return  [.portrait]
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // 만약에 백그라운드에서 push받으면
        let userInfo = userInfo as NSDictionary? as? [String: Any] ?? [:]
        guard let convertInfo = try? JSONSerialization.data(withJSONObject: userInfo.self, options: [.prettyPrinted]) else {return}
    
        let decoder = JSONDecoder()
        guard let json = try? decoder.decode(PushNotificationModel.self, from: convertInfo) else {return}
        
        // 끝난 푸시를 클릭하게 될 경우, 아무 데이터가 나오지 않기 때문에 아래 케이스에서 예외로 빠질 것으로 예상 (여기서 루트뷰 저장해주고 난뒤에 변경?
        if json.matched != nil {
            self.rootString = "채팅"
        } else if json.dodge != nil {
            print("취소, 따로 액션 취하지 않음")
        } else if json.hobbyAccepted != nil {
            self.rootString = "취미수락"
        } else if json.hobbyRequest != nil {
            self.rootString = "취미요청"
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 런치스크린 지연X
        Thread.sleep(forTimeInterval: 0.0)
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 들어오면 알림센터 뱃지 다 없애주는 역할
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // foreground 상태에서 alert 과 sound 띄어주는 거
        completionHandler([.list, .badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        // 들어온 상태에서는 이게 실행 됨, 베너 누르면 여기 들어오네
        let vc = BaseTabBarViewController()

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        if let root = self.rootString, root == "채팅" {
            vc.selectedIndex = 0
            windowScene.windows.first?.rootViewController = vc
            windowScene.windows.first?.makeKeyAndVisible()
        }

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
