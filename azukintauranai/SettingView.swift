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



struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var pushflg = true
    @State private var selectedIndex = 0    // 選択値と連携するプロパティ
    @Environment(\.openURL) var openURL

    let hourList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]

    var body: some View {
        NavigationStack() {
            ZStack {
                Color.customBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    Form {
                        Section {
                            Toggle(isOn: $pushflg) {
                                Text("お知らせの通知")
                            }
                            .onChange(of: pushflg) { newValue in
                                // ユーザーデフォルトを変更
                                UserDefaults.standard.set(newValue, forKey: "pushflg")

                                if (newValue) {
                                    // プッシュ通知登録
                                    sendNotificationRequest()
                                } else {
                                    // プッシュ通知削除
                                    deleteNotificationRequest()
                                }
                            }
                            .onAppear() {
                                // トグルの初期値設定
                                pushflg = savedPushFlg
                            }
                            
                            Picker(selection: $selectedIndex, label: Text("通知時間")) {
                                ForEach (0..<hourList.count, id: \.self) { index in
                                    Text(String(hourList[index]) + "時")
                                }
                            }
                            .onChange(of: selectedIndex) { newValue in
                                // ユーザーデフォルトを変更
                                UserDefaults.standard.set(newValue, forKey: "pushhour")
                                // グローバル変数も上書き
                                savedHour = newValue

                                // プッシュ通知オンの場合は プッシュ通知設定を変更する
                                if (pushflg) {
                                    // プッシュ通知登録
                                    sendNotificationRequest()
                                }
                            }
                            .onAppear() {
                                // ピッカーの初期値設定
                                selectedIndex = savedHour
                            }
                        } header: {
                            Text("通知設定")
                        }
                        
                        Section {
                            Link(destination: URL(string: "http://chigiramio.com/")!) {
                                HStack {
                                    Text("イラスト ちぎらみお")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(Font.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .opacity(0.5)
                                }
                            }
                            Link(destination: URL(string: "https://mojamoja-apps.com")!) {
                                HStack {
                                    Text("開発 mojamoja apps")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(Font.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .opacity(0.5)
                                }
                            }
                        } header: {
                            Text("リンク")
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
