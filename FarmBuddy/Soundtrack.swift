//
//  Soundtrack.swift
//  AFL3_MobCom
//
//  Created by MacBook Pro on 15/12/23.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?
var audioEffectPlayer: AVAudioPlayer?

func playSoundEffect(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioEffectPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioEffectPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}
