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
    
    
    var body: some View {
        NavigationStack() {
            ZStack {

                Color.customBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    Image("title")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 100)
                    
                    Image("top")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                    
                    HStack{
                        Button(action: {
                            isShowView = true
                        }){
                            Text("占う")
                                .font(.largeTitle)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(30)
                        
                        Button(action: {
                            isCalendarView = true
                        }){
                            Text("過去の占い結果")
                                .font(.largeTitle)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(30)
                    }
                    
                    Spacer()
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
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
