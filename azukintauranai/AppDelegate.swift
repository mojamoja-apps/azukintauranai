//
//  AppDelegate.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2023/01/31.
//

import Foundation
import UIKit

// プッシュ通知 参考
//https://tech.amefure.com/swift-notification

class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("許可されました！")
                UNUserNotificationCenter.current().delegate = self
                
                // 通知許可の場合スケジュール登録
                sendNotificationRequest()
            }else{
                print("拒否されました...")
            }
        }
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([[.banner, .list, .sound]])
    }
}
