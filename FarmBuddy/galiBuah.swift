import Foundation
import SwiftUI

struct Sayur: Identifiable {
    let id = UUID()
    var name: String
    var taps = 0
    var isAnimating = false
    var isHarvested = false
    var currentPosition: CGPoint = .zero
    var size: CGSize = CGSize(width: 160, height: 150)
    var isCorrectlyPlaced: Bool = false
}
struct Tanah: Identifiable {
    let id = UUID()
    var currentPosition: CGPoint = .zero
}
struct DigFruit: View {
    @Binding var isMusicPlaying: Bool
    
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    
    @Binding var displayMode: DisplayMode
    
    @State private var sayuran: [Sayur] = []
    @State private var tanahan: [Tanah] = []
    
    let maxTaps = 3
    @State private var angka: Int = Int.random(in: 1...7)
    let randomVegetableType = Bool.random() ? "radish" : "beetroot"
    
    @State private var selectedPieceID: UUID?
    @State private var activePieceID: UUID?
    @State private var activeDragOffset: CGSize = .zero
    
    @State private var correctlyPlacedBeetroots = 0
    @State private var correctlyPlacedRadishes = 0
    
    @State private var hasWon: Bool = false
    
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack{
                Image("stage carrot bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Button {
                    displayMode = .home
                } label: {
                    Image("panah")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: widthLayar * 0.05, y: heightLayar * 0.05))
                
                Button {
                    toggleMusic()
                } label:
                {
                    Image(isMusicPlaying ? "lagu" : "lagumati")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.1))
                
                Image("df-basket")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height:320)
                    .position(x: geometry.size.width / 2 + 210, y: geometry.size.height / 2 + 190)
                
                Image("awan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1000, height:1000)
                    .position(CGPoint(x: widthLayar * 0.73, y: heightLayar * 0.390))
                Image("df-\(randomVegetableType)-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height:140)
                    .position(CGPoint(x: widthLayar * 0.76, y: heightLayar * 0.35))
                
                Text("\(angka)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.red)
                    .position(CGPoint(x: widthLayar * 0.69, y: heightLayar * 0.376))
                
                
                Image("df-cewe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210)
                    .position(x: geometry.size.width - 150, y: geometry.size.height / 2 + 220)
                
                
                Image("df-tanah-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 650)
                    .position(x: geometry.size.width / 2-310, y: geometry.size.height / 2 + 90)
                
                Image("df-tanah-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 650)
                    .position(x: geometry.size.width / 2-310, y: geometry.size.height / 2 + 310)
                
                ForEach($sayuran) { $sayur in
                    if sayur.isHarvested == false {
                        Image("df-\(sayur.name)-2")
                            .resizable()
                            .scaledToFit()
                            .zIndex(sayur.id == selectedPieceID ? 2 : 1)
                            .frame(width: sayur.size.width, height: sayur.size.height)
                            .rotationEffect(.degrees(sayur.isAnimating ? 10 : 0))
                            .position(x: sayur.currentPosition.x, y: sayur.currentPosition.y)
                            .opacity(sayur.isAnimating ? 0.5 : 1.0)
                            .animation(sayur.isAnimating ? .easeInOut(duration: 0.15).repeatCount(5, autoreverses: true) : .default, value: sayur.isAnimating)
                            .onTapGesture {
                                if sayur.taps < maxTaps {
                                    sayur.taps += 1
                                    withAnimation {
                                        sayur.isAnimating = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        withAnimation {
                                            sayur.isAnimating = false
                                        }
                                    }
                                    if sayur.taps == maxTaps {
                                        sayur.isHarvested = true
                                    }
                                }
                            }
                    }
                    
                    if sayur.isHarvested == true {
                        Image("df-\(sayur.name)-1")
                            .resizable()
                            .scaledToFit()
                            .zIndex(sayur.id == selectedPieceID ? 3 : 2)
                            .frame(width: sayur.size.width, height: sayur.size.height)
                            .position(sayur.currentPosition)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        withAnimation() {
                                            selectedPieceID = sayur.id
                                            
                                            if activePieceID == nil {
                                                activePieceID = sayur.id
                                                activeDragOffset = CGSize(
                                                    width: sayur.currentPosition.x - gesture.location.x,
                                                    height: sayur.currentPosition.y - gesture.location.y
                                                )
                                            }
                                            if activePieceID == sayur.id {
                                                // Update the position only if the active piece ID matches
                                                sayur.currentPosition = CGPoint(
                                                    x: gesture.location.x + activeDragOffset.width,
                                                    y: gesture.location.y + activeDragOffset.height
                                                )
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        activePieceID = nil
                                        activeDragOffset = .zero
                                        let dropPosition = sayur.currentPosition
                                        
                                        let isInBox = dropPosition.x > geometry.size.width / 2 + 210 - (320 / 2) &&
                                        dropPosition.x < geometry.size.width / 2 + 210 + (320 / 2) &&
                                        dropPosition.y > geometry.size.height / 2 + 190 - (180 / 2) &&
                                        dropPosition.y < geometry.size.height / 2 + 190 + (180 / 2)
                                        
                                        print("Is in box: \(isInBox) ")
                                        
                                        if isInBox {
                                            sayur.isCorrectlyPlaced = true
                                            hitungBuah()
                                            checkWinCondition()
                                            withAnimation {
                                                if sayur.currentPosition.x < geometry.size.width / 2 + 210 - (215 / 2) { // kiri
                                                    sayur.currentPosition.x = geometry.size.width / 2 + 210 - (200 / 2)
                                                } else if sayur.currentPosition.x > geometry.size.width / 2 + 210 + (215 / 2) { // kanan
                                                    sayur.currentPosition.x = geometry.size.width / 2 + 210 + (200 / 2)
                                                }
                                                sayur.currentPosition.y = geometry.size.height / 2 + 150
                                                
                                                
                                            }
                                            
                                        } else {
                                            sayur.isCorrectlyPlaced = false
                                            hitungBuah()
                                        }
                                        print("beetroot :\(correctlyPlacedBeetroots)")
                                        print("radish :\(correctlyPlacedRadishes)")
                                    }
                                
                            )
                    }
                    
                }
                ForEach(tanahan) { tanah in
                    Image("df-tanah-2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .position(tanah.currentPosition)
                        .offset(y:70)
                    
                    Image("df-tanah-3")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .position(tanah.currentPosition)
                        .offset(y:70)
                }
                Image("df-basket-depan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 334, height:333)
                    .position(x: geometry.size.width / 2 + 214, y: geometry.size.height / 2 + 218)
                    .zIndex(5)
                if hasWon {
                    
                    ZStack{
                        Image("board")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.5)
                        
                        Button {
                            displayMode = .BuahHitung
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
                    }.zIndex(6)
                    
                }
                
            }
            .onAppear {
                // Inisialisasi sayuran berdasarkan geometry
                let beetrootPositions: [CGPoint] = [
                    //atas
                    CGPoint(x: geometry.size.width / 2 - 550, y: geometry.size.height / 2 + 90 - 100),
                    CGPoint(x: geometry.size.width / 2 - 370, y: geometry.size.height / 2 + 90 - 100),
                    CGPoint(x: geometry.size.width / 2 - 210, y: geometry.size.height / 2 + 90 - 100),
                    CGPoint(x: geometry.size.width / 2 - 60, y: geometry.size.height / 2 + 90 - 100),
                    
                    //bawah
                    CGPoint(x: geometry.size.width / 2 - 130, y: geometry.size.height / 2 + 90 - 40),
                    CGPoint(x: geometry.size.width / 2 - 290, y: geometry.size.height / 2 + 90 - 40),
                    CGPoint(x: geometry.size.width / 2 - 460, y: geometry.size.height / 2 + 90 - 40),
                ]
                
                
                let radishPositions: [CGPoint] = [
                    //atas
                    CGPoint(x: geometry.size.width / 2 - 550, y: geometry.size.height / 2 + 90 - 100 + 220),
                    CGPoint(x: geometry.size.width / 2 - 370, y: geometry.size.height / 2 + 90 - 100 + 220),
                    CGPoint(x: geometry.size.width / 2 - 210, y: geometry.size.height / 2 + 90 - 100 + 220),
                    CGPoint(x: geometry.size.width / 2 - 60, y: geometry.size.height / 2 + 90 - 100 + 220),
                    
                    //bawah
                    CGPoint(x: geometry.size.width / 2 - 130, y: geometry.size.height / 2 + 90 - 40 + 220),
                    CGPoint(x: geometry.size.width / 2 - 290, y: geometry.size.height / 2 + 90 - 40 + 220),
                    CGPoint(x: geometry.size.width / 2 - 460, y: geometry.size.height / 2 + 90 - 40 + 220),
                ]
                let tanahPositions: [CGPoint] = [
                    CGPoint(x: geometry.size.width / 2 - 550, y: geometry.size.height / 2 + 90 - 100),
                    CGPoint(x: geometry.size.width / 2 - 370, y: geometry.size.height / 2 + 90 - 100),
                    CGPoint(x: geometry.size.width / 2 - 210, y: geometry.size.height / 2 + 90 - 100),
                    CGPoint(x: geometry.size.width / 2 - 60, y: geometry.size.height / 2 + 90 - 100),
                    
                    //bawah
                    CGPoint(x: geometry.size.width / 2 - 130, y: geometry.size.height / 2 + 90 - 40),
                    CGPoint(x: geometry.size.width / 2 - 290, y: geometry.size.height / 2 + 90 - 40),
                    CGPoint(x: geometry.size.width / 2 - 460, y: geometry.size.height / 2 + 90 - 40),
                    
                    //atas
                    CGPoint(x: geometry.size.width / 2 - 550, y: geometry.size.height / 2 + 90 - 100 + 220),
                    CGPoint(x: geometry.size.width / 2 - 370, y: geometry.size.height / 2 + 90 - 100 + 220),
                    CGPoint(x: geometry.size.width / 2 - 210, y: geometry.size.height / 2 + 90 - 100 + 220),
                    CGPoint(x: geometry.size.width / 2 - 60, y: geometry.size.height / 2 + 90 - 100 + 220),
                    
                    //bawah
                    CGPoint(x: geometry.size.width / 2 - 130, y: geometry.size.height / 2 + 90 - 40 + 220),
                    CGPoint(x: geometry.size.width / 2 - 290, y: geometry.size.height / 2 + 90 - 40 + 220),
                    CGPoint(x: geometry.size.width / 2 - 460, y: geometry.size.height / 2 + 90 - 40 + 220),
                ]
                
                for beetrootPosition in beetrootPositions {
                    sayuran.append(Sayur(name: "beetroot", currentPosition: beetrootPosition))
                }
                
                for radishPosition in radishPositions {
                    sayuran.append(Sayur(name: "radish", currentPosition: radishPosition))
                }
                
                for tanahPosition in tanahPositions {
                    tanahan.append(Tanah(currentPosition: tanahPosition))
                }
            }
            
        }
        
    }
    private func checkWinCondition() {
        if randomVegetableType == "radish" && angka == correctlyPlacedRadishes{
            print("completed!")
            hasWon = true
        }
        if randomVegetableType == "beetroot" && angka == correctlyPlacedBeetroots{
            print("completed!")
            hasWon = true
        }
    }
    private func hitungBuah() {
        correctlyPlacedRadishes = 0
        correctlyPlacedBeetroots = 0
        for item in sayuran {
            if item.name == "radish" && item.isCorrectlyPlaced == true {
                correctlyPlacedRadishes += 1
            }
            if item.name == "beetroot" && item.isCorrectlyPlaced == true {
                correctlyPlacedBeetroots += 1
            }
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


struct puzzle_previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .DigFruit
    @State static var isMusicPlaying: Bool = true
    
    
    static var previews: some View {
        DigFruit(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
