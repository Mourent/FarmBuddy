//
//  BuahHitung.swift
//  AFL3_MobCom
//
//  Created by MacBook Pro on 27/11/23.
//

import SwiftUI


struct BuahHitung: View {
    @Binding var isMusicPlaying: Bool
    @State private var lastBuahPosition: [CGSize] = Array(repeating: .zero, count: 7)
    @State private var buahOffset: [CGSize] = Array(repeating: .zero, count: 7)
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    @State private var dataXAwal: [Int] = [
        (Int(UIScreen.main.bounds.width * 0.377)),
        (Int(UIScreen.main.bounds.width * 0.544)),
        (Int(UIScreen.main.bounds.width * 0.461)),
        (Int(UIScreen.main.bounds.width * 0.586)),
        (Int(UIScreen.main.bounds.width * 0.637)),
        (Int(UIScreen.main.bounds.width * 0.494)),
        (Int(UIScreen.main.bounds.width * 0.394))
    ]
    @State private var dataYAwal: [Int] = [
        (Int(UIScreen.main.bounds.height * 0.360)),
        (Int(UIScreen.main.bounds.height * 0.240)),
        (Int(UIScreen.main.bounds.height * 0.300)),
        (Int(UIScreen.main.bounds.height * 0.372)),
        (Int(UIScreen.main.bounds.height * 0.480)),
        (Int(UIScreen.main.bounds.height * 0.444)),
        (Int(UIScreen.main.bounds.height * 0.540))
    ]
    @State private var angka: Int = Int.random(in: 1...7)
    @State private var buahJatuh: [Bool] = Array(repeating: false, count: 7)
    @State private var applesInBasket: Int = 0
    @State private var box1Count: Int = 0
    @State private var box2Count: Int = 0
    @State private var showingBenar: Bool = false
    @State private var showingSalah: Bool = false
    @State private var isPeternakanHitungActive = false
    @State private var dragingAllow: [Bool] = Array(repeating: true, count: 7)
    @State private var boxPenuh: [Bool] = Array(repeating: false, count: 7)
    @State private var zIndexValues: [Double] = Array(repeating: 0.0, count: 7)
   
    @Binding var displayMode: DisplayMode
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
    
            Image("tree")
    
            Image("cewe")
                .position(CGPoint(x: (widthLayar * 0.15), y: heightLayar * 0.7))
    
            Image("box")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 150)
                .position(CGPoint(x: widthLayar * 0.711, y: heightLayar * 0.85))
            Image("box")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 150)
                .position(CGPoint(x: widthLayar * 0.861, y: heightLayar * 0.85))
            
            Image("board")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.13)
                .position(CGPoint(x: widthLayar * 0.785, y: heightLayar * 0.65))
            
            Text("\(applesInBasket)")
                .font(.system(size: 55, weight: .bold))
                .foregroundColor(.red)
                .position(CGPoint(x: widthLayar * 0.785, y: heightLayar * 0.659))
                .border(Color.black)
            
            Button {
//                isStartActive = true
                displayMode = .home
            } label: {
                Image("panah")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.05, y: heightLayar * 0.05))
            
            Button {
                //                isStartActive = true
                toggleMusic()
            } label: {
                Image(isMusicPlaying ? "lagu" : "lagumati")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.08))

            
            Button("SUBMIT") {
                if (applesInBasket == angka){
                    showingBenar = true
                }
                else {
                    showingSalah = true
                }
            }
            .padding()
            .background(Color(UIColor(red: 0x70/255.0, green: 0x9F/255.0, blue: 0x19/255.0, alpha: 1.0)))
            .shadow(radius: 50)
            .foregroundColor(.white)
            .font(.custom("PaytoneOne-Regular", size: 24))
            .cornerRadius(10)
            .position(x: widthLayar * 0.532, y: heightLayar * 0.915)
    
            ZStack{
                Image("awan")
                    .scaleEffect(x: -1, y: 1)
                    .position(CGPoint(x: widthLayar * 0.25, y: heightLayar * 0.420))
                Image("apple")
                    .position(CGPoint(x: widthLayar * 0.27, y: heightLayar * 0.401))
                Text("\(angka)")
                    .font(.system(size: 55, weight: .bold))
                    .foregroundColor(.red)
                    .position(CGPoint(x: widthLayar * 0.23, y: heightLayar * 0.404))
                    .border(Color.black)
            }
    
            ForEach(0..<7) { index in
                Image("apple")
                    .position(CGPoint(x: dataXAwal[index], y: dataYAwal[index]))
                    .offset(buahOffset[index])
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if dragingAllow[index] {
                                    if boxPenuh[index]{
                                        buahOffset[index] = CGSize(
                                            width: 0 + gesture.translation.width,
                                            height: 0 + gesture.translation.height
                                        )
                                        lastBuahPosition[index].width = 0
                                        lastBuahPosition[index].height = 0
                                    }
                                    if !boxPenuh[index]{
                                        if !buahJatuh[index]{
                                            buahOffset[index] = CGSize(
                                                width: lastBuahPosition[index].width + gesture.translation.width,
                                                height: lastBuahPosition[index].height + gesture.translation.height
                                            )
                                        } else {
                                            buahOffset[index] = CGSize(
                                                width: lastBuahPosition[index].width + gesture.translation.width,
                                                height: (heightLayar * 0.92 - CGFloat(dataYAwal[index])) + gesture.translation.height
                                            )
                                            lastBuahPosition[index].height = (heightLayar * 0.92 - CGFloat(dataYAwal[index]))
                                        }
                                    }
                                    }
                                }
                            .onEnded { gesture in
                                if dragingAllow[index] {
                                    boxPenuh[index] = false
                                    lastBuahPosition[index] = buahOffset[index]
                                
                                    let lastBuahX = Int(lastBuahPosition[index].width) + Int(dataXAwal[index])
                                    let lastBuahY = Int(lastBuahPosition[index].height) + Int(dataYAwal[index])
                                    
                                    if CGFloat(dataYAwal[index]) + lastBuahPosition[index].height < heightLayar * 0.85 {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            buahOffset[index] = CGSize(
                                                width: lastBuahPosition[index].width,
                                                height: (heightLayar * 0.92 - CGFloat(dataYAwal[index]))
                                            )
                                        }
                                        buahJatuh[index] = true
                                    }else {
                                        buahJatuh[index] = false
                                    }
                                    
                                    if (lastBuahX >= Int(widthLayar * 0.65) && lastBuahX <= Int(widthLayar * 0.765) && lastBuahY <= Int(heightLayar * 0.85)) {
                                        box1Count += 1
                                        if box1Count > 5 {
                                            withAnimation(.easeInOut(duration: 1.5)) {
                                                buahOffset[index] = CGSize(
                                                    width: widthLayar*0.705 - CGFloat(dataXAwal[index]),
                                                    height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                )
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                withAnimation(.easeInOut(duration: 1.5)) {
                                                    buahOffset[index] = CGSize(
                                                        width: 0,
                                                        height: 0
                                                    )
                                                }
                                            }
                                            boxPenuh[index] = true
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                applesInBasket += 1
                                                print(applesInBasket)
                                            }
                                            dragingAllow[index] = false
                                            if box1Count == 1 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.705 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.8
                                            } else if box1Count == 2 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.680 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.9
                                            } else if box1Count == 3 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.735 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.7
                                            } else if box1Count == 4 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.655 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 1.0
                                            } else if box1Count == 5 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.76 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.6
                                            }
                                        }
                                    } else if (lastBuahX >= Int(widthLayar * 0.81) && lastBuahX <= Int(widthLayar * 0.915) && lastBuahY <= Int(heightLayar * 0.85)) {
                                        box2Count += 1
                                        if box2Count > 5 {
                                            withAnimation(.easeInOut(duration: 1.5)) {
                                                buahOffset[index] = CGSize(
                                                    width: widthLayar*0.865 - CGFloat(dataXAwal[index]),
                                                    height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                )
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                withAnimation(.easeInOut(duration: 1.5)) {
                                                    buahOffset[index] = CGSize(
                                                        width: 0,
                                                        height: 0
                                                    )
                                                }
                                            }
                                            boxPenuh[index] = true
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                applesInBasket += 1
                                                print(applesInBasket)
                                            }
                                            dragingAllow[index] = false
                                            if box2Count == 1 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.865 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.3
                                            } else if box2Count == 2 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.840 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.4
                                            } else if box2Count == 3 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.890 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.2
                                            } else if box2Count == 4 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.815 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.5
                                            } else if box2Count == 5 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.910 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.83 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.1
                                            }
                                        }
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
                    displayMode = .buah
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
                }.zIndex(50)
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
    
                }.zIndex(50)
            }
        }
//        if isPeternakanHitungActive {
//            buah()
//            BuahHitung().hidden()
//        }
    }
    func reset(){
        angka = Int.random(in: 1...7)
        buahOffset = Array(repeating: .zero, count: 7)
        lastBuahPosition = Array(repeating: .zero, count: 7)
        applesInBasket = 0
        box1Count = 0
        box2Count = 0
        buahJatuh = Array(repeating: false, count: 7)
        dragingAllow = Array(repeating: true, count: 7)
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

//#Preview {
//
//
//    BuahHitung(displayMode: $displayMode)
//}

struct BuahHitung_Previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .BuahHitung
    @State static var isMusicPlaying: Bool = true

    static var previews: some View {
        BuahHitung(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
