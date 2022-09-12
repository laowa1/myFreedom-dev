//
//  AppDelegate.swift
//  MyFreedom
//
//  Created by Nazhmeddin Babakhan on 04.03.2022.
//

import UIKit
import Firebase
import OZLivenessSDK
import FirebaseMessaging
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let commonStore = CommonStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeRootView()
        setupServices()
        configureNotifications()
        commonStore.logger.initalize(id: "87474626215") // user phone number
        window?.overrideUserInterfaceStyle = .unspecified
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        commonStore.logger.didBecomeActive()
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return YMMYandexMetrica.handleOpen(url)
    }
    
    func configureNotifications() {
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
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func application(_: UIApplication, openURL url: URL, sourceApplication _: String?, annotation _: AnyObject) -> Bool {
        return YMMYandexMetrica.handleOpen(url)
    }
    
    private func application(_: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler _: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                YMMYandexMetrica.handleOpen(url)
            }
        }
        return true
    }
}

// MARK: - Private Configuration
private extension AppDelegate {

    func initializeRootView() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let initialRouter = InitialRouter(commonStore: commonStore, window: window)
        window.rootViewController = initialRouter.build()
        commonStore.rootWindow = window
        window.makeKeyAndVisible()
        self.window = window
    }

    func setupServices() {
        setupOZ()
        FirebaseApp.configure()
    }

    func setupOZ() {
        OZSDK.configure(with: "https://oz-api-bank.ffin.kz")
        OZSDK.customization.buttonColor.darkColor = BaseColor.base500
        OZSDK.customization.buttonColor.lightColor = BaseColor.green500
        OZSDK.customization.textColor = .systemGreen
        OZSDK.customization.faceFrameCustomization.strokeWidth = 2
        OZSDK.customization.faceFrameCustomization.failStrokeColor = BaseColor.red900
        OZSDK.customization.faceFrameCustomization.successStrokeColor = BaseColor.green500
        OZSDK.customization.faceFrameCustomization.geometryType = .oval

        do {
            try OZSDK.set(licenseBundle: .main)
        } catch {
            print("error", error)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.alert, .sound, .badge]])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {

    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        guard let fcmToken = fcmToken else { return }

        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Firebase", error.localizedDescription)
    }
}

//MARK: - AppsFlyer
extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(" user info \(userInfo)")
        commonStore.logger.appsFlyerManager.handlePushNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        commonStore.logger.appsFlyerManager.handleOpenURL(url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        commonStore.logger.appsFlyerManager.handleOpenURL(url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        commonStore.logger.appsFlyerManager.handlePushNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        commonStore.logger.appsFlyerManager.continueUserActivity(userActivity, restorationHandler: nil)
        return true
    }
}
