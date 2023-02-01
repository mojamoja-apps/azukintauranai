//
//  azukintauranaiApp.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2022/12/26.
//

import SwiftUI

@main
struct azukintauranaiApp: App {
    // 初期処理を行う
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TopView()
        }
    }
}

