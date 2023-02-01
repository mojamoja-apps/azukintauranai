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


var resultSound00 = try! AVAudioPlayer(data: NSDataAsset(name: "00")!.data)
var resultSound01 = try! AVAudioPlayer(data: NSDataAsset(name: "01")!.data)
var resultSound02 = try! AVAudioPlayer(data: NSDataAsset(name: "02")!.data)
var resultSound03 = try! AVAudioPlayer(data: NSDataAsset(name: "03")!.data)
var resultSound04 = try! AVAudioPlayer(data: NSDataAsset(name: "04")!.data)
func playResultSound(ppp: AVAudioPlayer) {
    ppp.stop()
    ppp.currentTime = 0.0
    ppp.play()
}

private let pokuSound = try! AVAudioPlayer(data: NSDataAsset(name: "poku")!.data)
private let muonSound = try! AVAudioPlayer(data: NSDataAsset(name: "muon")!.data)
func playMuon() {
    muonSound.stop()
    muonSound.currentTime = 0.0
    muonSound.play()
}
func playPoku() {
    pokuSound.stop()
    pokuSound.currentTime = 0.0
    pokuSound.play()
}

struct TopView: View {
    @State var isResutlView = false
    @State var isCalendarView = false
    @State var isSettingView = false

    var body: some View {
        NavigationStack() {
            ZStack {
                Color.customBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        Spacer()

                        Image("title")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 100)

                        Image("top")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 350)

                        VStack{
                            Button(action: {
                                isResutlView = true
                            }){
                                Text("占う")
                                    .font(.system(size:25))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(3)

                            Button(action: {
                                isCalendarView = true
                            }){
                                Text("過去の占い結果")
                                    .font(.system(size:25))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(3)

                            Button(action: {
                                isSettingView = true
                            }){
                                Text("設定")
                                    .font(.system(size:25))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(3)
                        }

                        Spacer()
                    }
                }

                .navigationDestination(isPresented: $isResutlView) {
                    ResultView()
                }
                .navigationDestination(isPresented: $isCalendarView) {
                    CalendarView()
                }
                .navigationDestination(isPresented: $isSettingView) {
                    SettingView()
                }
            }
        }
        .onAppear() {
            playMuon()
// テスト結果を作る
//            UserDefaults.standard.set("0", forKey: "2023-01-01")
//            UserDefaults.standard.set("1", forKey: "2023-01-02")
//            UserDefaults.standard.set("2", forKey: "2023-01-03")
//            UserDefaults.standard.set("3", forKey: "2023-01-06")
//            UserDefaults.standard.set("4", forKey: "2023-01-10")
//            UserDefaults.standard.set("0", forKey: "2023-01-11")
//            UserDefaults.standard.set("1", forKey: "2023-01-13")
//            UserDefaults.standard.set("2", forKey: "2023-01-20")
//            UserDefaults.standard.set("3", forKey: "2023-01-21")
//            UserDefaults.standard.set("4", forKey: "2023-01-22")
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
