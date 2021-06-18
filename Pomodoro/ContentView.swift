//
//  ContentView.swift
//  Pomodoro
//
//  Created by ggolfz on 18/6/2564 BE.
//

import SwiftUI
import AVFoundation
var timeTarget = 1500
struct ContentView: View {
    @State var time = timeTarget
    @State var isStart = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var soundEffect:AVAudioPlayer?
    
    
    func getTimeDisplay(time: Int) -> String {
        let minute = time / 60
        let second = time % 60
        let minuteText: String
        let secondText: String
        if(minute < 10){
            minuteText = "0\(minute)"
        } else {
            minuteText = "\(minute)"
        }
        if(second < 10 && minute > 0) {
            secondText = "0\(second)"
        } else {
            secondText = "\(second)"
        }
        if(minute == 0){
            return secondText
        }
        return "\(minuteText):\(secondText)"
    }
    var body: some View {
        VStack {
            ZStack{
                Image("Tomato").resizable().aspectRatio(contentMode: .fit).frame(width:140, height: 160, alignment: .top)
                Circle().stroke(lineWidth: 16.0).opacity(0.3).foregroundColor(.accentColor.opacity(0.5))
                Circle().trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: CGFloat((timeTarget-time))/CGFloat(timeTarget)).stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round)).foregroundColor(.accentColor)
                Text("\(getTimeDisplay(time: time))").font(time < 60 ? .largeTitle : .title)
            }.onReceive(timer) { input in
            self.time -= 1
                if(self.time == 0) {
                    timer.connect().cancel();
                    self.soundEffect?.play()
                }
        }
            Spacer(minLength: 20)
            if(!isStart) {
        Button(action: {
            self.timer = Timer.publish(every: 1, on: .main, in: .common);
            _ = timer.connect();
            self.isStart = true;
            do {
                self.soundEffect =  try AVAudioPlayer(data: NSDataAsset(name:"SoundEffect")!.data)
            } catch _ {
                return
            }
        }) {
            Text("Start")
        }
            }
            if(isStart) {
            Button(action: {
                self.timer.connect().cancel();
                self.isStart = false;
                self.time = timeTarget;
            }) {
                Text("Stop")
            }
            }
        }.padding().frame(width: 260, height: 260, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
