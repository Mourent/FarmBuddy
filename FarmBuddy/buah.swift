//
//  ContentView.swift
//  AFL3_MobCom
//
//  Created by MacBook Pro on 22/11/23.
//

import SwiftUI
import CoreData

struct buah: View {
    @Binding var isMusicPlaying: Bool
    @State private var lastBuahPosition: [CGSize] = Array(repeating: .zero, count: 9)
    @State private var buahOffset: [CGSize] = Array(repeating: .zero, count: 9)
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    @State private var randomImageName: [String] = (0..<9).map { _ in Bool.random() ? "apple" : "lemon" }
    @State private var dataXAwal: [Int] = [
        (Int(UIScreen.main.bounds.width * 0.377)),
        (Int(UIScreen.main.bounds.width * 0.461)),
        (Int(UIScreen.main.bounds.width * 0.586)),
        (Int(UIScreen.main.bounds.width * 0.637)),
        (Int(UIScreen.main.bounds.width * 0.464)),
        (Int(UIScreen.main.bounds.width * 0.394)),
        (Int(UIScreen.main.bounds.width * 0.454)),
        (Int(UIScreen.main.bounds.width * 0.554)),
        (Int(UIScreen.main.bounds.width * 0.544))
    ]
    @State private var dataYAwal: [Int] = [
        (Int(UIScreen.main.bounds.height * 0.360)),
        (Int(UIScreen.main.bounds.height * 0.300)),
        (Int(UIScreen.main.bounds.height * 0.372)),
        (Int(UIScreen.main.bounds.height * 0.480)),
        (Int(UIScreen.main.bounds.height * 0.510)),
        (Int(UIScreen.main.bounds.height * 0.570)),
        (Int(UIScreen.main.bounds.height * 0.420)),
        (Int(UIScreen.main.bounds.height * 0.240)),
        (Int(UIScreen.main.bounds.height * 0.470))
    ]
    @State private var applesInBasket: Int = 0
    @State private var lemonsInBasket: Int = 0
    @State private var showingBenar: Bool = false
    @State private var showingSalah: Bool = false
    @State private var isPeternakanHitungActive = false
    @State private var isStartActive = false
    @State private var winCount: Int = 0
    @State private var appleCount: Int = 0
    @State private var lemonCount: Int = 0
    @State private var buahJatuh: [Bool] = Array(repeating: false, count: 9)
    @State private var salahMasuk: [Bool] = Array(repeating: false, count: 9)
    @State private var dragingAllow: [Bool] = Array(repeating: true, count: 9)
    @State private var zIndexValues: [Double] = Array(repeating: 0.0, count: 9)
    @Binding var displayMode: DisplayMode
    @State private var simpanPerubahanWidth: [CGFloat] = []
    @State private var simpanPerubahanHeight: [CGFloat] = []
    @State private var tabrak: [Bool] = Array(repeating: false, count: 9)

    @Environment(\.managedObjectContext) private var viewContext
    private func addItemCount(itemId: String,count:Int32) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_item == %@", itemId)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let itemToReduce = results.first {
                itemToReduce.count += count  // Asumsikan Anda memiliki property `count` pada entitas `Item`
                try viewContext.save()
                print("ke db")
                
            }
        } catch let error as NSError {
            // Handle errors here
            print("Error nambah item count: \(error), \(error.userInfo)")
        }
    }

    var body: some View {
        ZStack {
            
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Image("tree")
            
            
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
            Button {
                displayMode = .shop
            } label:{
                Image("shop-logo")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.08 + 80))
            
            Image("box")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 150)
                .position(CGPoint(x: widthLayar * 0.811, y: heightLayar * 0.81))
            
            Image("box")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 150)
                .position(CGPoint(x: widthLayar * 0.241, y: heightLayar * 0.81))
            
            Image("papanapple")
                .position(CGPoint(x: widthLayar * 0.811, y: heightLayar * 0.65))
            
            Image("papanlemon")
                .position(CGPoint(x: widthLayar * 0.241, y: heightLayar * 0.65))
            
            ForEach(0..<9) { index in
                Image("\(randomImageName[index])")
                    .position(CGPoint(x: dataXAwal[index], y: dataYAwal[index]))
                    .offset(buahOffset[index])
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if dragingAllow[index]{
                                    if salahMasuk[index]{
                                        buahOffset[index] = CGSize(
                                            width: 0 + gesture.translation.width,
                                            height: 0 + gesture.translation.height
                                        )
                                        lastBuahPosition[index].width = 0
                                        lastBuahPosition[index].height = 0
                                    }
                                    if !salahMasuk[index]{
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
                            .onEnded{ gesture in
                                if dragingAllow[index]{
                                    salahMasuk[index] = false
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
                                    
                                    if randomImageName[index] == "apple" {
                                        if (lastBuahX >= Int(widthLayar * 0.76) && lastBuahX <= Int(widthLayar * 0.865) && lastBuahY <= Int(heightLayar * 0.8)) {
                                            winCount += 1
                                            appleCount += 1
                                            print(winCount)
                                            
                                            if appleCount == 1 || appleCount > 5 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.813 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.3
                                            } else if appleCount == 2 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.789 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.4
                                            } else if appleCount == 3 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.837 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.2
                                            } else if appleCount == 4 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.765 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.5
                                            } else if appleCount == 5 {
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.86 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.1
                                            }
                                            
                                            dragingAllow[index] = false
                                        } else if (lastBuahX >= Int(widthLayar * 0.19) && lastBuahX <= Int(widthLayar * 0.3) && lastBuahY <= Int(heightLayar * 0.8)) {
                                            withAnimation(.easeInOut(duration: 1.5)) {
                                                buahOffset[index] = CGSize(
                                                    width: widthLayar*0.24 - CGFloat(dataXAwal[index]),
                                                    height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
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
                                            salahMasuk[index] = true
                                        }
                                    } else {
                                        if (lastBuahX >= Int(widthLayar * 0.19) && lastBuahX <= Int(widthLayar * 0.3) && lastBuahY <= Int(heightLayar * 0.8)) {
                                            winCount += 1
                                            lemonCount += 1
                                            print(winCount)
                                            
                                            if lemonCount == 1 || lemonCount > 5{
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.24 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.8
                                            } else if lemonCount == 2{
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.215 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.9
                                            }else if lemonCount == 3{
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.265 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.7
                                            }else if lemonCount == 4{
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.190 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 1.0
                                            }else if lemonCount == 5{
                                                withAnimation(.easeInOut(duration: 1.0)) {
                                                    buahOffset[index] = CGSize(
                                                        width: widthLayar*0.290 - CGFloat(dataXAwal[index]),
                                                        height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
                                                    )
                                                }
                                                zIndexValues[index] = 0.6
                                            }
                                            
                                            
                                            dragingAllow[index] = false
                                        } else if (lastBuahX >= Int(widthLayar * 0.76) && lastBuahX <= Int(widthLayar * 0.865) && lastBuahY <= Int(heightLayar * 0.8)) {
                                            withAnimation(.easeInOut(duration: 1.5)) {
                                                buahOffset[index] = CGSize(
                                                    width: widthLayar*0.813 - CGFloat(dataXAwal[index]),
                                                    height: (heightLayar * 0.79 - CGFloat(dataYAwal[index]))
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
                                            salahMasuk[index] = true
                                        }

                                    }
                                    
                                    if winCount == 9 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showingBenar = true
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
                        addItemCount(itemId: "1", count: Int32(Int.random(in: 1...4)))
                        addItemCount(itemId: "7", count: Int32(Int.random(in: 1...4)))
                        displayMode = .HewanMasuk
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
                }
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


struct Buah_Previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .buah
    @State static var isMusicPlaying: Bool = true

    static var previews: some View {
        buah(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
