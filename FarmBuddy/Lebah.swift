//
//  ContentView.swift
//  HitungLebah
//
//  Created by MacBook Pro on 06/01/24.
//

import SwiftUI

struct Lebah: View {
    @Binding var isMusicPlaying: Bool
    @Binding var displayMode: DisplayMode
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    @State private var lastBeePosition: [CGSize] = Array(repeating: .zero, count: 8)
    @State private var beeOffset: [CGSize] = Array(repeating: .zero, count: 8)
    @State private var angka: Int = Int.random(in: 1...8)
    @State private var beeScaleFactor: [CGFloat] = Array(repeating: 1.0, count: 8)
    @State private var zIndexValues: [Double] = Array(repeating: 0.0, count: 8)
    @State private var dataXAwal: [Int] = [
        (Int(UIScreen.main.bounds.width * 0.5)),
        (Int(UIScreen.main.bounds.width * 0.55)),
        (Int(UIScreen.main.bounds.width * 0.35)),
        (Int(UIScreen.main.bounds.width * 0.45)),
        (Int(UIScreen.main.bounds.width * 0.65)),
        (Int(UIScreen.main.bounds.width * 0.65)),
        (Int(UIScreen.main.bounds.width * 0.75)),
        (Int(UIScreen.main.bounds.width * 0.8))
    ]
    @State private var dataYAwal: [Int] = [
        (Int(UIScreen.main.bounds.height * 0.2)),
        (Int(UIScreen.main.bounds.height * 0.7)),
        (Int(UIScreen.main.bounds.height * 0.6)),
        (Int(UIScreen.main.bounds.height * 0.4)),
        (Int(UIScreen.main.bounds.height * 0.3)),
        (Int(UIScreen.main.bounds.height * 0.5)),
        (Int(UIScreen.main.bounds.height * 0.7)),
        (Int(UIScreen.main.bounds.height * 0.4))
    ]
    @State private var dragingAllow: [Bool] = Array(repeating: true, count: 8)
    @State private var beeCount = 0
    @State private var layerBee: Double = 1
    @State private var showingBenar: Bool = false
    @State private var showingSalah: Bool = false
    
    var body: some View {
        ZStack{
            Image("bglebah")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Button {
                //                back
                displayMode = .home
            } label: {
                Image("panah")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.05, y: heightLayar * 0.03))
            
            Button {
                //                isStartActive = true
                toggleMusic()
            } label: {
                Image(isMusicPlaying ? "lagu" : "lagumati")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.96, y: heightLayar * 0.05))
            
            Button("SUBMIT") {
                if (beeCount == angka){
                    showingBenar = true
                }
                else {
                    showingSalah = true
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .shadow(radius: 50)
            .foregroundColor(.white)
            .font(.custom("PaytoneOne-Regular", size: 24))
            .cornerRadius(20)
            .position(x: widthLayar * 0.5, y: heightLayar * 0.85)
            
            Image("boy")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 400)
                .position(CGPoint(x: widthLayar * 0.2, y: heightLayar * 0.62))
            
            Image("awan")
                .scaleEffect(x: -1, y: 1)
                .position(CGPoint(x: widthLayar * 0.3, y: heightLayar * 0.33))
            Image("bee")
                .resizable()
                .scaledToFill()
                .frame(width:70, height:60)
                .position(CGPoint(x: widthLayar * 0.325, y: heightLayar * 0.31))
            Text("\(angka)")
                .font(.system(size: 55, weight: .bold))
                .foregroundColor(.red)
                .position(CGPoint(x: widthLayar * 0.275, y: heightLayar * 0.319))
            
            Image("hive1")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 400)
                .position(CGPoint(x: widthLayar * 0.94, y: heightLayar * 0.3))
            Image("hive")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 240)
                .position(CGPoint(x: widthLayar * 0.945, y: heightLayar * 0.33))
            
            ForEach(0..<8) { index in
                Image("bee")
                    .resizable()
                    .scaledToFill()
                    .frame(width:90, height:70)
                    .scaleEffect(beeScaleFactor[index])
                    .position(CGPoint(x: dataXAwal[index], y: dataYAwal[index]))
                    .offset(beeOffset[index])
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if dragingAllow[index] {
                                    beeOffset[index] = CGSize(
                                        width: lastBeePosition[index].width + gesture.translation.width,
                                        height: lastBeePosition[index].height + gesture.translation.height
                                    )
                                    zIndexValues[index] = layerBee
                                    layerBee += 1
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow[index] {
                                    lastBeePosition[index] = beeOffset[index]
                                    
                                    let lastBeeX = Int(lastBeePosition[index].width) + Int(dataXAwal[index])
                                    let lastBeeY = Int(lastBeePosition[index].height) + Int(dataYAwal[index])
                                    
                                    if (lastBeeX >= Int(widthLayar * 0.94) && lastBeeX <= Int(widthLayar * 0.99) && lastBeeY >= Int(heightLayar * 0.3) && lastBeeY <= Int(heightLayar * 0.38)) {
                                        beeCount += 1
                                        print(beeCount)
                                        withAnimation {
                                            beeScaleFactor[index] *= 0.4
                                        }
                                        dragingAllow[index] = false
                                    }
                                                                        
                                }
                            }
                    ).zIndex(zIndexValues[index])
            }
            if showingBenar {
                ZStack{
                    Image("board")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                    
                    Button {
                        //                    isPeternakanHitungActive = true
                        displayMode = .Ikan
                    } label: {
                        Image("next")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.25)
                    }
                    .position(CGPoint(x: widthLayar * 0.52, y: heightLayar * 0.55))
                    
                    Text("Next")
                        .foregroundColor(.black)
                        .font(.custom("PaytoneOne-Regular", size: 50))
                        .position(CGPoint(x: widthLayar * 0.51, y: heightLayar * 0.4))
                    Text("Correct")
                        .foregroundColor(.white)
                        .font(.custom("PaytoneOne-Regular", size: 50))
                        .position(CGPoint(x: widthLayar * 0.515, y: heightLayar * 0.26))
                }
            }
            if showingSalah {
                ZStack{
                    Image("board")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                    
                    Button {
                        reset()
                        showingSalah = false
                    } label: {
                        Image("tryagain")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.2)
                    }
                    .position(CGPoint(x: widthLayar * 0.52, y: heightLayar * 0.55))
                    
                    Text("Try Again")
                        .foregroundColor(.black)
                        .font(.custom("PaytoneOne-Regular", size: 50))
                        .position(CGPoint(x: widthLayar * 0.52, y: heightLayar * 0.4))
                    Text("Wrong")
                        .foregroundColor(.white)
                        .font(.custom("PaytoneOne-Regular", size: 50))
                        .position(CGPoint(x: widthLayar * 0.515, y: heightLayar * 0.26))
                    
                }
            }
        }
    }
    func reset(){
        angka = Int.random(in: 1...8)
        beeOffset = Array(repeating: .zero, count: 8)
        lastBeePosition = Array(repeating: .zero, count: 8)
        beeScaleFactor = Array(repeating: 1.0, count: 8)
        beeCount = 0
        dragingAllow = Array(repeating: true, count: 8)
        layerBee = 1
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

struct Lebah_Previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .Lebah
    @State static var isMusicPlaying: Bool = true

    static var previews: some View {
        Lebah(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
