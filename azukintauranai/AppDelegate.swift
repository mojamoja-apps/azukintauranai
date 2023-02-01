//
//  AppDelegate.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2023/01/31.
//

import Foundation
import UIKit


// プッシュ通知ヤルフラグ
var savedPushFlg = false
// プッシュ通知時間
var savedHour = 0
// 通知ID
let notificationID = "あずきんた1"

// プッシュ通知 参考
//https://tech.amefure.com/swift-notification
// https://kumonosu.cloudsquare.jp/program/swift/post-3770/

class AppDelegate:NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // プッシュ通知やるか ユーザーデフォルトから取得 無ければやる
        savedPushFlg = UserDefaults.standard.object(forKey: "pushflg") as? Bool ?? true
        // プッシュ時間 ユーザーデフォルトから取得 無ければ9
        savedHour = UserDefaults.standard.object(forKey: "pushhour") as? Int ?? 9
        
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

// プッシュ通知
func sendNotificationRequest(){
    let content = UNMutableNotificationContent()
    content.title = "今日の運勢を"
    content.body = "占ってみよう！そーれそーれ！"
    content.sound = UNNotificationSound.default
    //これではうまく鳴らなかった content.sound = UNNotificationSound.init(named: UNNotificationSoundName(: "poku"))

    var dateComponentsDay = DateComponents()
    // 時間はユーザーデフォルトから
    dateComponentsDay.hour = savedHour
    // 分は0固定
    dateComponentsDay.minute = 0

    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)

    let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

// プッシュ削除
func deleteNotificationRequest(){
    // 通知の削除
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
}
