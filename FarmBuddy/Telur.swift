//
//  ContentView.swift
//  StageTernak
//
//  Created by MacBook Pro on 18/12/23.
//

import SwiftUI
import CoreData
struct Telur: View {
    @Binding var isMusicPlaying: Bool
    @Binding var displayMode: DisplayMode
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    @State private var lastTelurPosition1: [CGSize] = Array(repeating: .zero, count: 1)
    @State private var telurOffset1: [CGSize] = Array(repeating: .zero, count: 1)
    @State private var lastTelurPosition2: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var telurOffset2: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var lastTelurPosition3: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var telurOffset3: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var lastTelurPosition4: [CGSize] = Array(repeating: .zero, count: 2)
    @State private var telurOffset4: [CGSize] = Array(repeating: .zero, count: 2)
    @State private var lastTelurPosition5: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var telurOffset5: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var lastTelurPosition6: [CGSize] = Array(repeating: .zero, count: 2)
    @State private var telurOffset6: [CGSize] = Array(repeating: .zero, count: 2)
    @State private var dragingAllow1: Bool = true
    @State private var dragingAllow2: [Bool] = Array(repeating: true, count: 3)
    @State private var dragingAllow3: [Bool] = Array(repeating: true, count: 3)
    @State private var dragingAllow4: [Bool] = Array(repeating: true, count: 2)
    @State private var dragingAllow5: [Bool] = Array(repeating: true, count: 3)
    @State private var dragingAllow6: [Bool] = Array(repeating: true, count: 2)
    @State private var zIndex: Double = 0.0
    @State private var zIndexValues1: [Double] = Array(repeating: 0.0, count: 1)
    @State private var zIndexValues2: [Double] = Array(repeating: 0.0, count: 3)
    @State private var zIndexValues3: [Double] = Array(repeating: 0.0, count: 3)
    @State private var zIndexValues4: [Double] = Array(repeating: 0.0, count: 2)
    @State private var zIndexValues5: [Double] = Array(repeating: 0.0, count: 3)
    @State private var zIndexValues6: [Double] = Array(repeating: 0.0, count: 2)
    @State private var telurInBasket: Int = 0
    @State private var showingBenar: Bool = false
    @State private var showingSalah: Bool = false
    @State private var sarang1: Int = Int.random(in: 0...1)
    @State private var sarang2: Int = Int.random(in: 1...3)
    @State private var sarang3: Int = Int.random(in: 1...3)
    @State private var sarang4: Int = Int.random(in: 1...2)
    @State private var sarang5: Int = Int.random(in: 1...3)
    @State private var sarang6: Int = Int.random(in: 1...2)
    @State private var xSarang23: [Int] = [
            (Int(UIScreen.main.bounds.width * 0.515)),
            (Int(UIScreen.main.bounds.width * 0.475)),
            (Int(UIScreen.main.bounds.width * 0.495))
    ]
    @State private var ySarang26: [Int] = [
            (Int(UIScreen.main.bounds.height * 0.415)),
            (Int(UIScreen.main.bounds.height * 0.415)),
            (Int(UIScreen.main.bounds.height * 0.41))
    ]
    @State private var ySarang345: [Int] = [
            (Int(UIScreen.main.bounds.height * 0.6)),
            (Int(UIScreen.main.bounds.height * 0.6)),
            (Int(UIScreen.main.bounds.height * 0.595))
    ]
    @State private var xSarang4: [Int] = [
            (Int(UIScreen.main.bounds.width * 0.375)),
            (Int(UIScreen.main.bounds.width * 0.345))
    ]
    @State private var xSarang5: [Int] = [
            (Int(UIScreen.main.bounds.width * 0.66)),
            (Int(UIScreen.main.bounds.width * 0.62)),
            (Int(UIScreen.main.bounds.width * 0.64))
    ]
    @State private var xSarang6: [Int] = [
            (Int(UIScreen.main.bounds.width * 0.775)),
            (Int(UIScreen.main.bounds.width * 0.755))
    ]
    private var jumlahTelur: Int {
            return sarang1 + sarang2 + sarang3 + sarang4 + sarang5 + sarang6
        }
    @State private var angka: Int = 0
    @State private var miring: [Double] = [0, -30, -15]
    
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
            Image("stage ayam telur")
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
            .position(CGPoint(x: widthLayar * 0.05, y: heightLayar * 0.08))
            
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
                displayMode = .shop
            } label:{
                Image("shop-logo")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width:100,height:80)
            .position(CGPoint(x: widthLayar * 0.95, y: heightLayar * 0.08 + 80))
            Button("SUBMIT") {
                if (telurInBasket == angka){
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
            .position(x: widthLayar * 0.5, y: heightLayar * 0.95)

            Image("cewek")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 500)
                .position(CGPoint(x: widthLayar * 0.9, y: heightLayar * 0.7))
            
            Image("Asset 1")
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 500)
                .position(CGPoint(x: widthLayar * 0.5, y: heightLayar * 0.755))
            
                Image("awan")
                    .position(CGPoint(x: widthLayar * 0.79, y: heightLayar * 0.3))
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-15))
                    .position(CGPoint(x: widthLayar * 0.805, y: heightLayar * 0.28))
                Text("\(angka)")
                    .font(.system(size: 55, weight: .bold))
                    .foregroundColor(.red)
                    .position(CGPoint(x: widthLayar * 0.76, y: heightLayar * 0.28))
                    .border(Color.black)
            
            
            Image("keranjang")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .position(CGPoint(x: widthLayar * 0.5, y: heightLayar * 0.85))
            
            Image("ayam berdiri")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .position(CGPoint(x: widthLayar * 0.37, y: heightLayar * 0.34))
            
            ForEach(0..<sarang1, id: \.self) { index in
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-15))
                    .position(CGPoint(x: widthLayar * 0.355, y: heightLayar * 0.425))
                    .offset(telurOffset1[index])
                    .gesture(
                         DragGesture()
                            .onChanged { gesture in
                                if dragingAllow1 {
                                    telurOffset1[index] = CGSize(
                                        width: lastTelurPosition1[index].width + gesture.translation.width,
                                        height: lastTelurPosition1[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow1 {
                                    lastTelurPosition1[index] = telurOffset1[index]
                                  
                                    let lastBuahX = Int(lastTelurPosition1[index].width) + Int(widthLayar * 0.355)
                                                            
                                    let lastBuahY = Int(lastTelurPosition1[index].height) + Int(heightLayar * 0.425)
                                    
                                    if lastBuahX >= Int(widthLayar * 0.43) && lastBuahX <= Int(widthLayar * 0.57) && lastBuahY >= Int(heightLayar * 0.755) && lastBuahY <= Int(heightLayar * 0.86) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            telurOffset1[index] = CGSize(
                                                width: lastTelurPosition1[index].width,
                                                height: heightLayar * 0.83 - heightLayar * 0.425
                                            )
                                        }
                                        dragingAllow1 = false
                                        zIndex += 0.1
                                        zIndexValues1[index] = zIndex
                                        
                                        telurInBasket += 1
                                        print(telurInBasket)
                                    }
                                }
                            }
                    ).zIndex(zIndexValues1[index])
            }
            Image("sarang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .position(CGPoint(x: widthLayar * 0.359, y: heightLayar * 0.44))

            ForEach(0..<sarang2, id: \.self) { index in
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(miring[index]))
                    .position(CGPoint(x: xSarang23[index], y: ySarang26[index]))
                    .offset(telurOffset2[index])
                    .gesture(
                         DragGesture()
                            .onChanged { gesture in
                                if dragingAllow2[index] {
                                    telurOffset2[index] = CGSize(
                                        width: lastTelurPosition2[index].width + gesture.translation.width,
                                        height: lastTelurPosition2[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow2[index] {
                                    lastTelurPosition2[index] = telurOffset2[index]
                                    
                                    let lastBuahX = Int(lastTelurPosition2[index].width) + Int(xSarang23[index])
                                                            
                                    let lastBuahY = Int(lastTelurPosition2[index].height) + Int(ySarang26[index])
                                    
                                    if lastBuahX >= Int(widthLayar * 0.43) && lastBuahX <= Int(widthLayar * 0.57) && lastBuahY >= Int(heightLayar * 0.755) && lastBuahY <= Int(heightLayar * 0.86) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            telurOffset2[index] = CGSize(
                                                width: lastTelurPosition2[index].width,
                                                height: heightLayar * 0.83 - CGFloat(ySarang26[index])
                                            )
                                        }
                                        dragingAllow2[index] = false
                                        zIndex += 0.1
                                        zIndexValues2[index] = zIndex
                                        
                                        telurInBasket += 1
                                        print(telurInBasket)
                                    }
                                }
                            }
                    ).zIndex(zIndexValues2[index])
            }
            Image("sarang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .position(CGPoint(x: widthLayar * 0.495, y: heightLayar * 0.44))
            
            ForEach(0..<sarang3, id: \.self) { index in
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(miring[index]))
                    .position(CGPoint(x: xSarang23[index], y: ySarang345[index]))
                    .offset(telurOffset3[index])
                    .gesture(
                         DragGesture()
                            .onChanged { gesture in
                                if dragingAllow3[index] {
                                    telurOffset3[index] = CGSize(
                                        width: lastTelurPosition3[index].width + gesture.translation.width,
                                        height: lastTelurPosition3[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow3[index] {
                                    lastTelurPosition3[index] = telurOffset3[index]
                                    
                                    let lastBuahX = Int(lastTelurPosition3[index].width) + Int(xSarang23[index])
                                                            
                                    let lastBuahY = Int(lastTelurPosition3[index].height) + Int(ySarang345[index])
                                    
                                    if lastBuahX >= Int(widthLayar * 0.43) && lastBuahX <= Int(widthLayar * 0.57) && lastBuahY >= Int(heightLayar * 0.755) && lastBuahY <= Int(heightLayar * 0.86) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            telurOffset3[index] = CGSize(
                                                width: lastTelurPosition3[index].width,
                                                height: heightLayar * 0.83 - CGFloat(ySarang345[index])
                                            )
                                        }
                                        dragingAllow3[index] = false
                                        zIndex += 0.1
                                        zIndexValues3[index] = zIndex
                                        
                                        telurInBasket += 1
                                        print(telurInBasket)
                                    }
                                }
                            }
                    ).zIndex(zIndexValues3[index])
            }
            Image("sarang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .position(CGPoint(x: widthLayar * 0.495, y: heightLayar * 0.62))
            
            ForEach(0..<sarang4, id: \.self) { index in
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(miring[index]))
                    .position(CGPoint(x: xSarang4[index], y: ySarang345[index]))
                    .offset(telurOffset4[index])
                    .gesture(
                         DragGesture()
                            .onChanged { gesture in
                                if dragingAllow4[index] {
                                    telurOffset4[index] = CGSize(
                                        width: lastTelurPosition4[index].width + gesture.translation.width,
                                        height: lastTelurPosition4[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow4[index] {
                                    lastTelurPosition4[index] = telurOffset4[index]
                                    
                                    let lastBuahX = Int(lastTelurPosition4[index].width) + Int(xSarang4[index])
                                                            
                                    let lastBuahY = Int(lastTelurPosition4[index].height) + Int(ySarang345[index])
                                    
                                    if lastBuahX >= Int(widthLayar * 0.43) && lastBuahX <= Int(widthLayar * 0.57) && lastBuahY >= Int(heightLayar * 0.755) && lastBuahY <= Int(heightLayar * 0.86) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            telurOffset4[index] = CGSize(
                                                width: lastTelurPosition4[index].width,
                                                height: heightLayar * 0.83 - CGFloat(ySarang345[index])
                                            )
                                        }
                                        dragingAllow4[index] = false
                                        zIndex += 0.1
                                        zIndexValues4[index] = zIndex
                                        
                                        telurInBasket += 1
                                        print(telurInBasket)
                                    }
                                }
                            }
                    ).zIndex(zIndexValues4[index])
            }
            Image("sarang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .position(CGPoint(x: widthLayar * 0.36, y: heightLayar * 0.62))
            
            ForEach(0..<sarang5, id: \.self) { index in
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(miring[index]))
                    .position(CGPoint(x: xSarang5[index], y: ySarang345[index]))
                    .offset(telurOffset5[index])
                    .gesture(
                         DragGesture()
                            .onChanged { gesture in
                                if dragingAllow5[index] {
                                    telurOffset5[index] = CGSize(
                                        width: lastTelurPosition5[index].width + gesture.translation.width,
                                        height: lastTelurPosition5[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow5[index] {
                                    lastTelurPosition5[index] = telurOffset5[index]
                                    
                                    let lastBuahX = Int(lastTelurPosition5[index].width) + Int(xSarang5[index])
                                                            
                                    let lastBuahY = Int(lastTelurPosition5[index].height) + Int(ySarang345[index])
                                    
                                    if lastBuahX >= Int(widthLayar * 0.43) && lastBuahX <= Int(widthLayar * 0.57) && lastBuahY >= Int(heightLayar * 0.755) && lastBuahY <= Int(heightLayar * 0.86) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            telurOffset5[index] = CGSize(
                                                width: lastTelurPosition5[index].width,
                                                height: heightLayar * 0.83 - CGFloat(ySarang345[index])
                                            )
                                        }
                                        dragingAllow5[index] = false
                                        zIndex += 0.1
                                        zIndexValues5[index] = zIndex
                                        
                                        telurInBasket += 1
                                        print(telurInBasket)
                                    }
                                }
                            }
                    ).zIndex(zIndexValues5[index])
            }
            Image("sarang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .position(CGPoint(x: widthLayar * 0.634, y: heightLayar * 0.62))
            
            ForEach(0..<sarang6, id: \.self) { index in
                Image("telur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(miring[index]))
                    .position(CGPoint(x: xSarang6[index], y: ySarang26[index]))
                    .offset(telurOffset6[index])
                    .gesture(
                         DragGesture()
                            .onChanged { gesture in
                                if dragingAllow6[index] {
                                    telurOffset6[index] = CGSize(
                                        width: lastTelurPosition6[index].width + gesture.translation.width,
                                        height: lastTelurPosition6[index].height + gesture.translation.height
                                    )
                                }
                            }
                            .onEnded{ gesture in
                                if dragingAllow6[index] {
                                    lastTelurPosition6[index] = telurOffset6[index]
                                    
                                    let lastBuahX = Int(lastTelurPosition6[index].width) + Int(xSarang6[index])
                                                            
                                    let lastBuahY = Int(lastTelurPosition6[index].height) + Int(ySarang26[index])
                                    
                                    if lastBuahX >= Int(widthLayar * 0.43) && lastBuahX <= Int(widthLayar * 0.57) && lastBuahY >= Int(heightLayar * 0.755) && lastBuahY <= Int(heightLayar * 0.86) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            telurOffset6[index] = CGSize(
                                                width: lastTelurPosition6[index].width,
                                                height: heightLayar * 0.83 - CGFloat(ySarang26[index])
                                            )
                                        }
                                        dragingAllow6[index] = false
                                        zIndex += 0.1
                                        zIndexValues6[index] = zIndex
                                        
                                        telurInBasket += 1
                                        print(telurInBasket)
                                    }
                                }
                            }
                    ).zIndex(zIndexValues6[index])
            }
            Image("sarang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .position(CGPoint(x: widthLayar * 0.765, y: heightLayar * 0.44))
            
            Image("keranjang depan")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .position(CGPoint(x: widthLayar * 0.5, y: heightLayar * 0.854))
                .zIndex(zIndex + 10)
            
            if showingBenar {
                ZStack{
                    Image("board")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                    
                    Button {
                        addItemCount(itemId: "4", count: Int32(Int.random(in: 1...5)))
                        displayMode = .Lebah
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
                        .position(CGPoint(x: widthLayar * 0.50, y: heightLayar * 0.285))
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
                        updateAngka()
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
                        .position(CGPoint(x: widthLayar * 0.503, y: heightLayar * 0.285))
                    
                }
            }

        }.onAppear {
            self.updateAngka()
        }
    }
    
    private func updateAngka() {
        angka = Int.random(in: 4...jumlahTelur)
    }
    func reset() {
        telurOffset1 = Array(repeating: .zero, count: 1)
        telurOffset2 = Array(repeating: .zero, count: 3)
        telurOffset3 = Array(repeating: .zero, count: 3)
        telurOffset4 = Array(repeating: .zero, count: 2)
        telurOffset5 = Array(repeating: .zero, count: 3)
        telurOffset6 = Array(repeating: .zero, count: 2)
        lastTelurPosition1 = Array(repeating: .zero, count: 1)
        lastTelurPosition2 = Array(repeating: .zero, count: 3)
        lastTelurPosition3 = Array(repeating: .zero, count: 3)
        lastTelurPosition4 = Array(repeating: .zero, count: 2)
        lastTelurPosition5 = Array(repeating: .zero, count: 3)
        lastTelurPosition6 = Array(repeating: .zero, count: 2)
        telurInBasket = 0
        dragingAllow1 = true
        dragingAllow2 = Array(repeating: true, count: 3)
        dragingAllow3 = Array(repeating: true, count: 3)
        dragingAllow4 = Array(repeating: true, count: 2)
        dragingAllow5 = Array(repeating: true, count: 3)
        dragingAllow6 = Array(repeating: true, count: 2)
        zIndex = 0.0
        sarang1 = Int.random(in: 0...1)
        sarang2 = Int.random(in: 1...3)
        sarang3 = Int.random(in: 1...3)
        sarang4 = Int.random(in: 1...2)
        sarang5 = Int.random(in: 1...3)
        sarang6 = Int.random(in: 1...2)
        zIndexValues1 = Array(repeating: 0.0, count: 1)
        zIndexValues2 = Array(repeating: 0.0, count: 3)
        zIndexValues3 = Array(repeating: 0.0, count: 3)
        zIndexValues4 = Array(repeating: 0.0, count: 2)
        zIndexValues5 = Array(repeating: 0.0, count: 3)
        zIndexValues6 = Array(repeating: 0.0, count: 2)
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

struct Telur_Previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .Telur
    @State static var isMusicPlaying: Bool = true

    static var previews: some View {
        Telur(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
