//
//  ContentView.swift
//  StageIkan
//
//  Created by MacBook Pro on 09/01/24.
//

import SwiftUI

struct Ikan: View {
    @Binding var isMusicPlaying: Bool
    @Binding var displayMode: DisplayMode
    @State private var showingBenar: Bool = false
    @State private var showingSalah: Bool = false
    @State private var lastIkanPosition: [CGSize] = Array(repeating: .zero, count: 5)
    @State private var ikanOffset: [CGSize] = Array(repeating: .zero, count: 5)
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    @State private var angka: Int = Int.random(in: 0...4)
    @State private var ikan: [String] = ["ikan 1", "ikan 2", "ikan 3", "ikan 4", "ikan 5"]
    @State private var dataXAwal: [Int] = [
           (Int(UIScreen.main.bounds.width * 0.25)),
           (Int(UIScreen.main.bounds.width * 0.55)),
           (Int(UIScreen.main.bounds.width * 0.2)),
           (Int(UIScreen.main.bounds.width * 0.83)),
           (Int(UIScreen.main.bounds.width * 0.55))
       ]
       @State private var dataYAwal: [Int] = [
           (Int(UIScreen.main.bounds.height * 0.25)),
           (Int(UIScreen.main.bounds.height * 0.5)),
           (Int(UIScreen.main.bounds.height * 0.5)),
           (Int(UIScreen.main.bounds.height * 0.37)),
           (Int(UIScreen.main.bounds.height * 0.25))
       ]
    @State private var simpan: Int?
    @State private var ikanDiBasket: Int = 0
    @State private var ikanSalah: [Bool] = Array(repeating: false, count: 5)
    @State private var zIndexValues: [Double] = Array(repeating: 0.0, count: 5)
    @State private var layer: Double = 1
    
    var body: some View {
        ZStack {
            Image("bgikan")
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
            .position(CGPoint(x: widthLayar * 0.05, y: heightLayar * 0.06))
            
            Button {
                //                isStartActive = true
                toggleMusic()
            } label: {
                Image(isMusicPlaying ? "lagu" : "lagumati")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.07))
            
            Button("SUBMIT") {
                if (simpan == angka){
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
            .position(x: widthLayar * 0.5, y: heightLayar * 0.92)
            
            Image("board")
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 250)
                .position(x: widthLayar * 0.83, y: heightLayar * 0.76)
            
            Image(ikan[angka])
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .position(x: widthLayar * 0.833, y: heightLayar * 0.772)
            
            Image("basketikan")
                .position(x: widthLayar * 0.5, y: heightLayar * 0.75)
            
            ForEach(0..<5) { index in
                Image(ikan[index])
                    .position(CGPoint(x: dataXAwal[index], y: dataYAwal[index]))
                    .offset(ikanOffset[index])
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                zIndexValues[index] = layer
                                layer += 1
                                if ikanDiBasket >= 1 && ikanSalah[index]{
                                    ikanOffset[index] = CGSize(
                                        width: 0 + gesture.translation.width,
                                        height: 0 + gesture.translation.height
                                    )
                                    lastIkanPosition[index].width = 0
                                    lastIkanPosition[index].height = 0
                                    ikanSalah[index] = false
                                } else {
                                    ikanOffset[index] = CGSize(
                                        width: lastIkanPosition[index].width + gesture.translation.width,
                                        height: lastIkanPosition[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                lastIkanPosition[index] = ikanOffset[index]
                                
                                let lastIkanX = Int(lastIkanPosition[index].width) + Int(dataXAwal[index])
                                let lastIkanY = Int(lastIkanPosition[index].height) + Int(dataYAwal[index])
                                
                                isFishInBasket()
                                print(ikanDiBasket)
                                
                                if (lastIkanX >= Int(widthLayar * 0.45) && lastIkanX <= Int(widthLayar * 0.55) &&
                                    lastIkanY >= Int(heightLayar * 0.6) && lastIkanY <= Int(heightLayar * 0.8)) {
                                    if ikanDiBasket <= 1{
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            ikanOffset[index] = CGSize(
                                                width: widthLayar*0.5 - CGFloat(dataXAwal[index]),
                                                height: (heightLayar * 0.7 - CGFloat(dataYAwal[index]))
                                            )
                                        }
                                        simpan = index
                                    } else if ikanDiBasket > 1 {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            ikanOffset[index] = CGSize(
                                                width: widthLayar*0.5 - CGFloat(dataXAwal[index]),
                                                height: (heightLayar * 0.7 - CGFloat(dataYAwal[index]))
                                            )
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            withAnimation(.easeInOut(duration: 1.5)) {
                                                ikanOffset[index] = CGSize(
                                                    width: 0,
                                                    height: 0
                                                )
                                            }
                                        }
                                        lastIkanPosition[index].width = 0
                                        lastIkanPosition[index].height = 0
                                        ikanSalah[index] = true
                                    }
                                }
                            }
                    ).zIndex(zIndexValues[index])
                
                Image("basketikan1")
                    .position(x: widthLayar * 0.5015, y: heightLayar * 0.783)
                    .zIndex(layer + 1)
                
                if showingBenar {
                    ZStack{
                        Image("board")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.5)
                        
                        Button {
                            displayMode = .PuzzlePage
                            //                    isPeternakanHitungActive = true
                        } label: {
                            Image("next")
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(0.25)
                        }
                        .position(CGPoint(x: widthLayar * 0.51, y: heightLayar * 0.57))
                        
                        Text("Next")
                            .foregroundColor(.black)
                            .font(.custom("PaytoneOne-Regular", size: 50))
                            .position(CGPoint(x: widthLayar * 0.5, y: heightLayar * 0.42))
                        Text("Correct")
                            .foregroundColor(.white)
                            .font(.custom("PaytoneOne-Regular", size: 50))
                            .position(CGPoint(x: widthLayar * 0.50, y: heightLayar * 0.275))
                    }.zIndex(layer + 50)
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
                        .position(CGPoint(x: widthLayar * 0.51, y: heightLayar * 0.57))
                        
                        Text("Try Again")
                            .foregroundColor(.black)
                            .font(.custom("PaytoneOne-Regular", size: 50))
                            .position(CGPoint(x: widthLayar * 0.51, y: heightLayar * 0.42))
                        Text("Wrong")
                            .foregroundColor(.white)
                            .font(.custom("PaytoneOne-Regular", size: 50))
                            .position(CGPoint(x: widthLayar * 0.503, y: heightLayar * 0.275))
                        
                    }.zIndex(layer + 50)
                }
            }
        }
    }
    func isFishInBasket() {
        ikanDiBasket = 0
        for index in 0..<5 {
            let lastIkanX = Int(lastIkanPosition[index].width) + Int(dataXAwal[index])
            let lastIkanY = Int(lastIkanPosition[index].height) + Int(dataYAwal[index])
            
            if (lastIkanX >= Int(widthLayar * 0.45) && lastIkanX <= Int(widthLayar * 0.55) &&
                lastIkanY >= Int(heightLayar * 0.6) && lastIkanY <= Int(heightLayar * 0.8)) {
                ikanDiBasket += 1
            }
        }
    }
    func reset(){
        angka = Int.random(in: 0...4)
        ikanOffset = Array(repeating: .zero, count: 5)
        lastIkanPosition = Array(repeating: .zero, count: 5)
        ikanDiBasket = 0
        ikanSalah = Array(repeating: false, count: 5)
        layer = 1
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

struct Ikan_Previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .Ikan
    @State static var isMusicPlaying: Bool = true

    static var previews: some View {
        Ikan(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
