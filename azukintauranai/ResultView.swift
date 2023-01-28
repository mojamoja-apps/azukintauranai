//
//  LaunchView.swift
//  azukintauranai
//
//  Created by 大塚匡平 on 2022/12/26.
//

import SwiftUI
import AVFoundation
import Combine
import Foundation

struct ResultView: View {
    @State var isShowResultView = false
    @State var pokuCount: Int = 0
    
    @State var rnd = 0
    @State var message_child_rnd = 0
    
    @Environment(\.dismiss) var dismiss
        
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.customBackgroundColor
                .ignoresSafeArea()
            VStack {
                
                if !isShowResultView {
                    Image("calc")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .onReceive(timer, perform: { _ in
                            pokuCount += 1
                            if pokuCount >= 5 {
                                timer.upstream.connect().cancel()
                                isShowResultView = true
                                return
                            }
                            playPoku()
                        })
                } else {
                    ScrollView {
                        Image("azukinta0" + String(rnd))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 350)
                            .onAppear() {
                                switch rnd {
                                case 0:
                                    // 大吉
                                    playResultSound(ppp:resultSound00)
                                case 1:
                                    // 中吉
                                    playResultSound(ppp:resultSound01)
                                case 2:
                                    // 小吉
                                    playResultSound(ppp:resultSound02)
                                case 3:
                                    // 凶
                                    playResultSound(ppp:resultSound03)
                                case 4:
                                    // 大凶
                                    playResultSound(ppp:resultSound04)
                                default:
                                    break
                                }
                                
                                // 結果を保存
                                saveResult(resultValue: rnd)
                            }
                        
                        Text("【" + uranai_titles[rnd] + "】")
                            .font(.system(size: 30))
                        
                        Text(uranai_messages[rnd][message_child_rnd])
                            .padding()
                        
                        Spacer()
                            .padding(.bottom, 50)
                        
                        Button(action: {
                            dismiss()
                        }){
                            Text("戻る")
                                .font(.largeTitle)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(30)
                        
                        Spacer()
                            .padding(.bottom, 50)
                    }
                }
            }
        }.onAppear(){
            rnd = Int.random(in: 0...4)
            // 子メッセージのランダム値を設定
            message_child_rnd = Int.random(in: 0...(uranai_messages[rnd].count - 1))
        }
    }
}

func saveResult(resultValue: Int) {
    // 結果を日付キーで保存
    let today = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateStyle = .medium
    dateFormatter.dateFormat = "yyyy-MM-dd"
      
    let todayStr = dateFormatter.string(from: today)

    UserDefaults.standard.set(String(resultValue), forKey: todayStr)
    
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
    }
}
