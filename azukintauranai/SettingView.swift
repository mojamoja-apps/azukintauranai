//
//  ContentView.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2022/12/26.
//

import SwiftUI
import AVFoundation
import Combine
import Foundation

// プッシュ通知
func sendNotificationRequest(){
    let content = UNMutableNotificationContent()
    content.title = "今日の運勢を"
    content.body = "占ってみよう！そーれそーれ！"
    content.sound = UNNotificationSound.default
    //これではうまく鳴らなかった content.sound = UNNotificationSound.init(named: UNNotificationSoundName(: "poku"))

    var dateComponentsDay = DateComponents()
    dateComponentsDay.hour = 23
    dateComponentsDay.minute = 56

    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)

    let request = UNNotificationRequest(identifier: "通知No.1", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var pushflag = true

    var body: some View {
        NavigationStack() {
            ZStack {
                Color.customBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    Form {
                        Toggle(isOn: $pushflag) {
                            //Text(pushflag ? "プッシュ通知" : "OFF")
                            Text("お知らせの通知")
                        }
                        .onChange(of: pushflag) { newValue in
                            if (newValue) {
                                // プッシュ通知登録
                                sendNotificationRequest()
                            } else {
                                // プッシュ通知削除
                            }
                            UserDefaults.standard.set(pushflag, forKey: "pushflag")
                        }
                        .onAppear() {
                            // トグルの初期値設定
                            let hoge = UserDefaults.standard.bool(forKey: "pushflag")
                            pushflag = hoge
                        }
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
