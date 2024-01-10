//
//  ContentView.swift
//  AFL3_MobCom
//
//  Created by MacBook Pro on 22/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    @State private var isBUAHActive = false
    @State private var displayMode: DisplayMode = .home
    @State private var isMusicPlaying: Bool = true
    var body: some View {
        
        switch displayMode {
        case .BuahHitung:
            BuahHitung(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file HewanMasukView.swift
        case .buah:
            buah(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)// View dari file BuahView.swift
        case .HewanMasuk:
            HewanMasuk(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file ModeKeempatView.swift
        case .Telur:
            Telur(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file ModeKeempatView.swift
        case .Lebah:
            Lebah(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file ModeKeempatView.swift
        case .Ikan:
            Ikan(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file ModeKeempatView.swift
        case .DigFruit:
            DigFruit(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file ModeKeempatView.swift
        case .PuzzlePage:
            PuzzlePage(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode) // View dari file ModeKeempatView.swift
        case .home:
            ZStack {
                Image("bgstart")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Button {
                    //                isStartActive = true
                    toggleMusic()
                } label: {
                    Image(isMusicPlaying ? "lagu" : "lagumati")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.1))

                
                Button {
//                    isBUAHActive = true
                    displayMode = .BuahHitung
                } label: {
                    Image("buttonplay")
                }
            }.onAppear{
                playSound(sound: "soundtrack", type: "mp3")
                isMusicPlaying = true
            }
            
//            if isBUAHActive {
//                BuahHitung()
//                ContentView().hidden()
//            }
        }
    }
    func toggleMusic() {
        if isMusicPlaying {
            audioPlayer?.stop()
        } else {
            audioPlayer?.play()
        }
        isMusicPlaying.toggle()
    }
}

enum DisplayMode {
    case home
    case buah
    case BuahHitung
    case HewanMasuk
    case Telur
    case Lebah
    case Ikan
    case PuzzlePage
    case DigFruit
}
#Preview {
    ContentView()
}
