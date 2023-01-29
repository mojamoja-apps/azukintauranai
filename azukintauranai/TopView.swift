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
    @State var isShowView = false
    @State var isCalendarView = false

    @Environment(\.openURL) var openURL

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
                                isShowView = true
                            }){
                                Text("占う")
                                    .font(.system(size:20))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(5)

                            Button(action: {
                                isCalendarView = true
                            }){
                                Text("過去の占い結果")
                                    .font(.system(size:20))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(5)

                            Button(action: {
                                openURL(URL(string: "http://chigiramio.com/")!)
                            }){
                                Image(systemName: "link")
                                Text("イラスト ちぎらみお")
                                    .font(.system(size:20))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(5)

                            Button(action: {
                                openURL(URL(string: "https://mojamoja-apps.com")!)
                            }){
                                Image(systemName: "link")
                                Text("開発 mojamoja apps")
                                    .font(.system(size:20))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(5)
                        }

                        Spacer()
                    }
                }

                .navigationDestination(isPresented: $isShowView) {
                    ResultView()
                }
                .navigationDestination(isPresented: $isCalendarView) {
                    CalendarView()
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
