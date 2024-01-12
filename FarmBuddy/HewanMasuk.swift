////
////  ContentView.swift
////  AFL3 Coba
////
////  Created by MacBook Pro on 27/11/23.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var lastDragPosition: CGPoint? = nil
//    @State private var forbiddenAreas: [CGRect] = []
//    @State private var forbiddenArea: CGRect = .zero
//    let numberOfChickens = 10
//
//      // Batasan untuk area tengah layar (misalnya, batas dari 100 hingga 300 secara horizontal dan vertikal)
//      let minX: CGFloat = 10
//      let maxX: CGFloat = 800
//      let minY: CGFloat = 300
//      let maxY: CGFloat = 400
//
//
//
//    var body: some View {
//        GeometryReader { fullGeometry in
//            ZStack {
//                // Background
//                Image("Bg")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .edgesIgnoringSafeArea(.all) // Mengabaikan area aman untuk memenuhi seluruh layar
//
//                // Konten utama
//                VStack{
//                    VStack {
//                        ForEach(0..<numberOfChickens, id: \.self) { _ in
//                            Image("Ayam")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 100, height: 100)
//                                .position(self.randomPositionExcludingForbiddenArea(in: fullGeometry.size))
//                                .overlay(
//                                    GeometryReader { geometry in
//                                        Color.clear.preference(key: ForbiddenAreaPreferenceKey.self, value: [geometry.frame(in: .global)])
//                                    }
//                                )
//                                .onPreferenceChange(ForbiddenAreaPreferenceKey.self) { preferences in
//                                    // Update state dengan area terlarang baru
//                                    self.forbiddenAreas = preferences
//                                }
//                            // Tambahkan lebih banyak elemen SwiftUI di sini
//                        }
//                        .padding()
//                        Spacer()
//                        HStack{
//                            Image("Kandang-kiri")
//                            Spacer()
//                            Image("Kandang-kanan")
//                        }
//                    }
//                    .padding(.vertical)
//                    .gesture(
//                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                            .onChanged { value in
//                                // Memperbarui posisi dengan lokasi terakhir dari sentuhan
//                                self.lastDragPosition = value.location
//                                print("Drag position: \(value.location)")
//                            }
//                            .onEnded { _ in
//                                // Mungkin menyimpan atau melakukan aksi lain ketika drag berakhir
//                                if let dragPosition = lastDragPosition {
//                                    print("Final drag position: \(dragPosition)")
//                                    // Anda bisa memperbarui nilai min dan max di sini
//                                }
//                            }
//                    )
//                }
//                .frame(width: fullGeometry.size.width, height: fullGeometry.size.height)
//            }
//        }
//    }
//    func randomPositionExcludingForbiddenArea(in size: CGSize) -> CGPoint {
//        var position: CGPoint
//        repeat {
//            // Generate a random position within min and max bounds
//            let x = CGFloat.random(in: minX...maxX)
//            let y = CGFloat.random(in: minY...maxY)
//            position = CGPoint(x: x, y: y)
//            // Check if the position is within the forbidden area
//        } while forbiddenArea.contains(position)
//
//        print(forbiddenArea)
//        return position
//    }
//
//}
//
//struct ForbiddenAreaPreferenceKey: PreferenceKey {
//    static var defaultValue: [CGRect] = []
//
//    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
//        value.append(contentsOf: nextValue())
//    }
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI
import CoreData
struct HewanMasuk: View {
    @Binding var isMusicPlaying: Bool
    @Binding var displayMode: DisplayMode
    @State private var forbiddenArea_Kandang_Kiri: CGRect = .zero
    @State private var forbiddenArea_Kandang_Kanan: CGRect = .zero
    @State private var forbiddenArea: CGRect = .zero
    @State private var activeDragZIndex: UUID?
    @State private var goGanti = false
    let numberOfChickens = Int.random(in: 5...10)
    @State private var chickens: [Chicken] = []
    let numberOfSheeps = Int.random(in: 5...10)
    @State private var sheeps: [Sheep] = []
    @State private var TotalNumber: Int = 10
    @State private var WinCounter: Int = 0
    @State private var showingBenar = false
    
    @State private var chickenSize: CGSize = CGSize(width: 100, height: 100) // Ukuran gambar ayam
    @State private var sheepSize: CGSize = CGSize(width: 150, height: 150)
    @State private var minX: CGFloat = 50
    @State private var maxX: CGFloat = 1000
    @State private var minY: CGFloat = 300
    @State private var maxY: CGFloat = 600
    
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
        GeometryReader { fullGeometry in
        
            ZStack {
            
                // Background
                Image("bgternak")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                Button {
    //                isStartActive = true
                    displayMode = .home
                } label: {
                    Image("panah")
                        .resizable()
                        .scaledToFit()
                }
                
                .frame(width:100,height:80)
                .position(CGPoint(x: fullGeometry.size.width * 0.05, y: fullGeometry.size.height * 0.05))
                
                Button {
                    //                isStartActive = true
                    toggleMusic()
                } label: {
                    Image(isMusicPlaying ? "lagu" : "lagumati")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: fullGeometry.size.width * 0.95, y: fullGeometry.size.height * 0.1))
                Button {
                    displayMode = .shop
                } label:{
                    Image("shop-logo")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width:100,height:80)
                .position(CGPoint(x: fullGeometry.size.width * 0.95, y: fullGeometry.size.height * 0.08 + 80))
                
                // Objek terlarang yang akan menentukan area terlarang
                
                //                Rectangle()
                //                    .fill(Color.red.opacity(0.5))
                //                    .frame(width: 550, height: 350)
                //                    .position(x: fullGeometry.size.width - 100, y: fullGeometry.size.height / 2 - 50)
                //                    .onAppear {
                //                        let rectangleWidth: CGFloat = 550
                //                        let rectangleHeight: CGFloat = 350
                //
                //                        // Menghitung posisi atas kiri dari Rectangle berdasarkan posisi tengahnya
                //                        let topLeftX = fullGeometry.size.width - 100 - rectangleWidth / 2
                //                        let topLeftY = fullGeometry.size.height / 2 - 50 - rectangleHeight / 2
                //
                //                        // Menetapkan forbiddenArea dengan ukuran dan posisi yang benar
                //                        self.forbiddenArea = CGRect(
                //                            x: topLeftX,
                //                            y: topLeftY,
                //                            width: rectangleWidth,
                //                            height: rectangleHeight
                //                        )
                //                    }
                
                
                let rectangleWidth: CGFloat = fullGeometry.size.width * 0.32
                let rectangleHeight: CGFloat = fullGeometry.size.height * 0.5
                let rectangleX = fullGeometry.size.width-(rectangleWidth/2)
                let rectangleY = fullGeometry.size.height * 0.4
                Rectangle()
                    .fill(Color.clear.opacity(0.5))
                    .frame(width: rectangleWidth, height: rectangleHeight)
                    .position(x:rectangleX
                              , y: rectangleY)
                    .onAppear {
                        
                        
                        // Menghitung posisi atas kiri dari Rectangle berdasarkan posisi tengahnya
                        let centerX = rectangleX
                        let centerY = rectangleY
                        
                        // Menghitung posisi atas kiri dari Rectangle
                        let topLeftX = centerX - rectangleWidth / 2
                        let topLeftY = centerY - rectangleHeight / 2
                        
                        
                        
                        // Menetapkan forbiddenArea dengan ukuran dan posisi yang benar
                        self.forbiddenArea = CGRect(
                            x: topLeftX,
                            y: topLeftY,
                            width: rectangleWidth,
                            height: rectangleHeight
                        )
                    }
                
                
                // Ayam dengan posisi acak yang tidak berada dalam area terlarang
                //                ForEach(0..<numberOfChickens, id: \.self) { index in
                //                    Image("Ayam")
                //                        .resizable()
                //                        .scaledToFit()
                //                        .frame(width: chickenSize.width, height: chickenSize.height)
                //                        .position(self.randomPositionExcludingForbiddenArea(in: fullGeometry.size))
                //                }
                
                ForEach($chickens) { $chicken in
                    Image("ayam")
                        .resizable()
                        .scaledToFit()
                        .frame(width: chickenSize.width, height: chickenSize.height)
                        .position(chicken.position)
                        .zIndex(chicken.id == activeDragZIndex ? fullGeometry.size.height+1 : chicken.position.y)
                    
                    //                        .zIndex(chicken.position.y)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !chicken.isInTargetBox {
                                        chicken.position = value.location
                                        self.activeDragZIndex = chicken.id
                                    }
                                }
                                .onEnded { value in
                                    self.activeDragZIndex = nil
                                    if !chicken.isInTargetBox {
                                        let chickenFrame = CGRect(x: value.location.x - chickenSize.width / 2 + (chickenSize.height * 0.2),
                                                                  y: value.location.y - chickenSize.height / 2 + (chickenSize.height * 0.2),
                                                                  width: chickenSize.width * 0.6,
                                                                  height: chickenSize.height * 0.6)
                                        
                                        
                                        let touchesLeftOrTop = chickenFrame.minX < 0 || chickenFrame.minY < 0
                                        
                                        // Mengecek batas layar kanan dan bawah
                                        let touchesRightOrBottom = chickenFrame.maxX > fullGeometry.size.width || chickenFrame.maxY > fullGeometry.size.height
                                        
                                        if forbiddenArea_Kandang_Kiri.contains(chickenFrame) {
                                            let randomX = CGFloat.random(in: (forbiddenArea_Kandang_Kiri.midX - 150)...(forbiddenArea_Kandang_Kiri.midX + 50))
                                            let randomY = CGFloat.random(in: (forbiddenArea_Kandang_Kiri.midY - 100)...(forbiddenArea_Kandang_Kiri.midY + 100))
                                            withAnimation(.easeInOut(duration: 1.0)) {
                                                
                                                chicken.position = CGPoint(x: randomX, y: randomY)
                                            }
                                            chicken.isInTargetBox = true
                                            WinCounter+=1
                                            if(WinCounter==TotalNumber){
                                                print("Win")
                                                goGanti=true
                                                showingBenar=true
                                                
                                            }
                                        }
                                        
                                        
                                        else if
                                            self.forbiddenArea_Kandang_Kiri.intersects(chickenFrame) ||
                                                self.forbiddenArea_Kandang_Kanan.intersects(chickenFrame) ||
                                                self.forbiddenArea.intersects(chickenFrame) || touchesLeftOrTop || touchesRightOrBottom  {
                                            // Ayam berada di area terlarang, cari zona aman terdekat
                                            withAnimation(.easeInOut(duration: 2.0)) {
                                                chicken.position = /*self.nearestSafeZonePosition(from: value.location, fullGeometry: fullGeometry.size)*/
                                                self.randomPositionExcludingForbiddenArea(in: fullGeometry.size)
                                            }
                                        }
                                    }
                                }
                        )
                }
                ForEach($sheeps) { $sheep in
                    Image("sheep")
                        .resizable()
                        .scaledToFit()
                        .frame(width: sheepSize.width, height: sheepSize.height)
                    //                        .overlay(
                    //                    Rectangle().fill(Color.blue.opacity(0.5))
                    //
                    //                    )
                        .position(sheep.position)
                        .zIndex(sheep.id == activeDragZIndex ? fullGeometry.size.height+1 : sheep.position.y)
                    //                        .zIndex(sheep.position.y)
                    
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !sheep.isInTargetBox {
                                        sheep.position = value.location
                                        self.activeDragZIndex = sheep.id
                                    }
                                }
                                .onEnded { value in
                                    self.activeDragZIndex = nil
                                    if !sheep.isInTargetBox {
                                        let sheepFrame = CGRect(x: value.location.x - sheepSize.width / 2 + (sheepSize.width * 0.2),
                                                                y: value.location.y - sheepSize.height / 2 + (sheepSize.height * 0.2),
                                                                width: sheepSize.width*0.6,
                                                                height: sheepSize.height*0.6)
                                        
                                        
                                        let touchesLeftOrTop = sheepFrame.minX < 0 || sheepFrame.minY < 0
                                        
                                        // Mengecek batas layar kanan dan bawah
                                        let touchesRightOrBottom = sheepFrame.maxX > fullGeometry.size.width || sheepFrame.maxY > fullGeometry.size.height
                                        
                                        if forbiddenArea_Kandang_Kanan.contains(sheepFrame) {
                                            let randomX = CGFloat.random(in: (forbiddenArea_Kandang_Kanan.midX - 50)...(forbiddenArea_Kandang_Kanan.midX + 150))
                                            let randomY = CGFloat.random(in: (forbiddenArea_Kandang_Kanan.midY - 100)...(forbiddenArea_Kandang_Kanan.midY + 100))
                                            withAnimation(.easeInOut(duration: 1.0)) {
                                                
                                                sheep.position = CGPoint(x: randomX, y: randomY)
                                            }
                                            sheep.isInTargetBox = true
                                            WinCounter+=1
                                            if(WinCounter==TotalNumber){
                                                print("Win")
                                                goGanti=true
                                                showingBenar=true
                                                
                                            }
                                        }
                                        
                                        
                                        else if
                                            self.forbiddenArea_Kandang_Kanan.intersects(sheepFrame) ||
                                                self.forbiddenArea_Kandang_Kiri.intersects(sheepFrame) ||
                                                self.forbiddenArea.intersects(sheepFrame) || touchesLeftOrTop || touchesRightOrBottom  {
                                            // Ayam berada di area terlarang, cari zona aman terdekat
                                            withAnimation(.easeInOut(duration: 2.0)) {
                                                sheep.position = /*self.nearestSafeZonePosition(from: value.location, fullGeometry: fullGeometry.size)*/
                                                self.randomPositionExcludingForbiddenArea(in: fullGeometry.size)
                                            }
                                        }
                                    }
                                }
                        )
                    
                }
                
                
                VStack{
                    Spacer()
                    
                    // HStack dengan gambar kandang
                    HStack {
                        
                        Image("Kandang-kiri")
                            .resizable()
                            .scaledToFit()
                            .frame(width: fullGeometry.size.width * 0.3 ) // Contoh: 20% dari lebar layar
                            .overlay(
                                GeometryReader { geometry in
                                    Rectangle().fill(Color.clear.opacity(0.5)) // Rectangle transparan
                                    
                                    Color.clear
                                        .onAppear {
                                            // Menghitung posisi atas kiri dari Rectangle berdasarkan posisi tengahnya
                                            let topLeftX = geometry.frame(in: .global).minX
                                            let topLeftY = geometry.frame(in: .global).minY
                                            let rectangleWidth = geometry.size.width
                                            let rectangleHeight = geometry.size.height
                                            
                                            // Menetapkan forbiddenArea dengan ukuran dan posisi yang benar
                                            self.forbiddenArea_Kandang_Kiri = CGRect(
                                                x: topLeftX,
                                                y: topLeftY,
                                                width: rectangleWidth,
                                                height: rectangleHeight
                                            )
                                        }
                                }
                            )
                        
                        Spacer()
                        
                        Image("Kandang-kanan")
                            .resizable()
                            .scaledToFit()
                            .frame(width: fullGeometry.size.width * 0.3) // Contoh: 20% dari tinggi layar
                            .overlay(                                GeometryReader { geometry in
                                
                                Rectangle().fill(Color.clear.opacity(0.5)) // Rectangle transparan
                                
                                Color.clear
                                    .onAppear {
                                        // Menghitung posisi atas kiri dari Rectangle berdasarkan posisi tengahnya
                                        let topLeftX = geometry.frame(in: .global).minX
                                        let topLeftY = geometry.frame(in: .global).minY
                                        let rectangleWidth = geometry.size.width
                                        let rectangleHeight = geometry.size.height
                                        
                                        // Menetapkan forbiddenArea dengan ukuran dan posisi yang benar
                                        self.forbiddenArea_Kandang_Kanan = CGRect(
                                            x: topLeftX,
                                            y: topLeftY,
                                            width: rectangleWidth,
                                            height: rectangleHeight
                                        )
                                        
                                    }
                            }
                                                                     
                            )
                        
                    }
                    .padding(.bottom,10) // Padding di bagian bawah
                    
                }
                VStack{
                    Spacer()
                    HStack{
                        Image("Kandang-kiri-front")
                            .resizable()
                            .scaledToFit()
                            .frame(width: fullGeometry.size.width * 0.3)
                            .overlay(
                                GeometryReader { geometry in
                                    
                                    Spacer()
                                    Rectangle().fill(Color.clear.opacity(0.5))
                                    
                                    
                                    Image("board")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: fullGeometry.size.width * 0.1)
                                        .overlay(
                                            Image("ayam")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: fullGeometry.size.width * 0.04),
                                            alignment: .center )
                                    //                                            .position(x:geometry.frame(in: .global).maxX-fullGeometry.size.width * 0.1,y:geometry.size.height/2
                                    //                                            + fullGeometry.size.width * 0.02)
                                        .position(x:geometry.size.width * 0.65,y:geometry.size.height * 0.6)
                                    
                                    
                                }
                            )
                        
                            .padding(.bottom,23)
                        Spacer()
                        Image("Kandang-kanan-front")
                            .resizable()
                            .scaledToFit()
                            .frame(width: fullGeometry.size.width * 0.3)
                            .overlay(
                                GeometryReader { geometry in
                                    
                                    Spacer()
                                    Rectangle().fill(Color.clear.opacity(0.5))
                                    
                                    
                                    Image("board")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: fullGeometry.size.width * 0.1)
                                        .overlay(
                                            Image("sheep")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: fullGeometry.size.width * 0.05),
                                            alignment: .center )
                                    //                                            .position(x:geometry.frame(in: .global).maxX-fullGeometry.size.width * 0.1,y:geometry.size.height/2
                                    //                                            + fullGeometry.size.width * 0.02)
                                        .position(x:geometry.size.width * 0.35,y:geometry.size.height * 0.55)
                                    
                                    
                                }
                            )
                    }
                    .padding(.bottom,10)
                }
                .zIndex(fullGeometry.size.height)
                
//                if goGanti {
//                    buah()
//                    HewanMasuk().hidden()
//                }
                
                if showingBenar {
                    ZStack{
                        Image("board")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.5)
                        
                    Button {
                        addItemCount(itemId: "3", count: Int32(Int.random(in: 1...3)))
                        addItemCount(itemId: "10", count: Int32(Int.random(in: 1...5)))
    //                    goHitungApel = true
                        displayMode = .Telur
                    } label: {
                        Image("next")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.25)
                    }
                    .position(CGPoint(x: fullGeometry.size.width * 0.51, y: fullGeometry.size.height * 0.57))
                        
                    Text("Next")
                        .foregroundColor(.black)
                        .font(.custom("PaytoneOne-Regular", size: 50))
                        .position(CGPoint(x: fullGeometry.size.width * 0.5, y: fullGeometry.size.height * 0.42))
                    Text("Correct")
                        .foregroundColor(.white)
                        .font(.custom("PaytoneOne-Regular", size: 50))
                        .position(CGPoint(x: fullGeometry.size.width * 0.50, y: fullGeometry.size.height * 0.285))
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    self.TotalNumber=numberOfSheeps+numberOfChickens
                    self.chickenSize=CGSize(width: fullGeometry.size.width*0.1, height: fullGeometry.size.width*0.1)
                    self.sheepSize=CGSize(width: fullGeometry.size.width*0.15, height: fullGeometry.size.width*0.15)
                    self.minX = fullGeometry.size.width*0.05
                    self.maxX = fullGeometry.size.width*0.95
                    self.minY = fullGeometry.size.height*0.35
                    self.maxY = fullGeometry.size.height*0.95
                    self.chickens = (0..<self.numberOfChickens).map { _ in
                        Chicken(position: self.randomPositionExcludingForbiddenArea(in: fullGeometry.size),isInTargetBox: false)
                    }
                    self.sheeps = (0..<self.numberOfSheeps).map { _ in
                        Sheep(position: self.randomPositionExcludingForbiddenArea(in: fullGeometry.size),isInTargetBox: false)
                    }
                    
                }
            }
            .frame(width: fullGeometry.size.width, height: fullGeometry.size.height)
           
        }
    }
    
    func randomPositionExcludingForbiddenArea(in size: CGSize) -> CGPoint {
        var position: CGPoint
        var chickenFrame:CGRect
        repeat {
            // Generate a random position within min and max bounds
            let x = CGFloat.random(in: minX...maxX)
            let y = CGFloat.random(in: minY...maxY)
            position = CGPoint(x: x, y: y)
            
            // Define chickenFrame here inside the repeat loop
            chickenFrame = CGRect(x: position.x - chickenSize.width / 2,
                                      y: position.y - chickenSize.height / 2,
                                      width: chickenSize.width,
                                      height: chickenSize.height)
            // Check if the chicken frame intersects the forbidden area
        } while forbiddenArea_Kandang_Kiri.intersects(chickenFrame) || forbiddenArea_Kandang_Kanan.intersects(chickenFrame) || forbiddenArea.intersects(chickenFrame)
        
        return position
    }
    func nearestSafeZonePosition(from location: CGPoint, fullGeometry: CGSize) -> CGPoint {
        // Asumsi: `safeZoneEdges` berisi nilai-nilai inset dari pinggir layar yang aman
        let safeZoneEdges = UIEdgeInsets(top: minY, left: minX, bottom: fullGeometry.height - maxY, right: fullGeometry.width - maxX)
        
        // Menghitung zona aman terdekat
        let safeX: CGFloat
        let safeY: CGFloat
        
        // Cek apakah lebih dekat ke batas horizontal atau vertikal dan atur posisi ke batas terdekat
        if location.x < safeZoneEdges.left {
            safeX = safeZoneEdges.left
        } else if location.x > fullGeometry.width - safeZoneEdges.right {
            safeX = fullGeometry.width - safeZoneEdges.right
        } else {
            safeX = location.x
        }
        
        if location.y < safeZoneEdges.top {
            safeY = safeZoneEdges.top
        } else if location.y > fullGeometry.height - safeZoneEdges.bottom {
            safeY = fullGeometry.height - safeZoneEdges.bottom
        } else {
            safeY = location.y
        }
        
        return CGPoint(x: safeX, y: safeY)
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
struct Chicken: Identifiable {
    let id = UUID()
    var position: CGPoint
    var isInTargetBox: Bool
}
struct Sheep: Identifiable {
    let id = UUID()
    var position: CGPoint
    var isInTargetBox: Bool
}


//#Preview {
//    HewanMasuk()
//}

struct HewanMasuk_Previews: PreviewProvider {
    @State static var displayMode: DisplayMode = .HewanMasuk
    @State static var isMusicPlaying: Bool = true


    static var previews: some View {
        HewanMasuk(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode)
    }
}
