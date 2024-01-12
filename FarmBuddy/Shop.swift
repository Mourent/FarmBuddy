//
//  Shop.swift
//  vifim
//
//  Created by MacBook Pro on 11/01/24.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData
import Foundation


struct Shop: View {
    @Binding var isMusicPlaying: Bool
    @Binding var displayMode: DisplayMode
    @State private var showCoin: Bool = false
    @State private var coinPosition: CGFloat = 0.0
    @State private var coinOpacity: Double = 1.0

    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var showingInventory = false
    @State private var draggingItem: Item?
    @State var dragState = DragState()
    @State private var heightLayar = UIScreen.main.bounds.height
    @State private var widthLayar = UIScreen.main.bounds.width
    //    // Misalkan ini adalah data dari inventory Anda
    //    let inventoryItems: [(name: String, image: String, count: Int)] = [
    //        ("Apple", "apple", 10),
    //        // Tambahkan lebih banyak item sesuai kebutuhan...
    //    ]
    // Contoh array count
    
    @State var buyers: [BuyerData] = loadBuyerData()
    @State private var droppedItem: Item?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var inventoryItemss: FetchedResults<Item>
    @State var currentIndex: Int=0
    @State var pages: Int=0
    //    var isipages: [Item]
    
    //    init() {
    //        let counts = inventoryItemss
    //        pages = Int((inventoryItemss.count-1)  / 8)
    ////        isipages = counts
    //    }
    
    
    var body: some View {
        
        
        GeometryReader { fullGeometry in
            let panjangBox=(fullGeometry.size.width*0.77)/4
            ZStack { // Layering your views
                // Background image of the shop
                Image("bg-shop") // Ganti dengan nama asset gambar toko Anda
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .onAppear(){
                        pages = Int((inventoryItemss.count-1)  / 8)
                        
                    }
                
                
                //                ZStack{
                Image("shop-dalem")
                    .resizable()
                    .scaledToFit()
                    .frame(width: fullGeometry.size.width*0.77)
                    .position(x:fullGeometry.size.width/2,y: fullGeometry.size.height*0.92/2)
                
                // ini page dalem
                
                //                        pageDalemView(currentIndex: $currentIndex, panjangBox: panjangBox, fullGeometry: fullGeometry, draggingItem: $draggingItem)
                pageDalemView(currentIndex: $currentIndex, panjangBox: panjangBox, fullGeometry: fullGeometry, draggingItem: $draggingItem, dragState: $dragState)
                
                
                //                if let draggedItem = dragState.draggedItem, dragState.isDragging {
                //                           ItemDragView(item: draggedItem, dragPosition: dragState.dragPosition)
                //                               .position(dragState.dragPosition ?? .zero)
                //                       }
                //                }
                //                    Image("hiasan")
                //                        .resizable()
                //                        .scaledToFit()
                //                        .frame(width: fullGeometry.size.width*0.77)
                //                        .position(x:fullGeometry.size.width/2,y: fullGeometry.size.height*0.6/2)
                //
                
                
                Image("shop")
                    .resizable()
                    .scaledToFill()
                    .frame(width: fullGeometry.size.width*1)
                    .position(x:fullGeometry.size.width/2,y: (fullGeometry.size.height*0.6)/2)
                    .opacity(0.9)
                    .allowsHitTesting(false)
                
                HStack(spacing: 30) {
                    ForEach(0..<3) { index in
                        VStack {
                            ZStack {
                                Image("box-jual")
                                    .resizable()
                                    .scaledToFit()
                                
                                DropAreaView(buyers: $buyers, index: index, droppedItem: $droppedItem,showCoin:$showCoin,coinPosition:$coinPosition,coinOpacity:$coinOpacity)
                                    .frame(height: fullGeometry.size.width * 0.4 / 3)
                                Image("golds") // Ganti dengan nama aset uang Anda
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: panjangBox/5, height: panjangBox/5)
                                    .opacity(showCoin ? coinOpacity : 0) // Uang tidak terlihat sampai showCoin adalah true
                                    .offset(y: coinPosition)
                                    .onAppear {
                                        // Trigger animasi saat view muncul atau berdasarkan kondisi tertentu
                                        withAnimation(.easeInOut(duration: 2.0)) {
                                            self.showCoin = true
                                            self.coinPosition = -100 // Atur ini sesuai dengan posisi dompet di UI Anda
                                            self.coinOpacity = 0 // Uang menjadi transparan di akhir animasi
                                        }
                                    }
                                
                            }
                            .frame(width: fullGeometry.size.width * 0.70 / 3)
                            
                            ZStack {
                                Image("pesenan")
                                    .resizable()
                                    .scaledToFit()
                                
                                OrderView(buyers: $buyers, index: index)
                                    .frame(width: fullGeometry.size.width * 0.65 / 3)
                            }
                            .frame(width: fullGeometry.size.width * 0.70 / 3)
                        }
                    }
                }.position(x:fullGeometry.size.width/2,y:fullGeometry.size.height*1.7/2)
                
                // Tempatkan ini di dalam body view Shop
                //                DropAreaView(droppedItem: $draggingItem)
                //                    .frame(width: fullGeometry.size.width/2, height: fullGeometry.size.height / 3)
                //                    .position(y:fullGeometry.size.height*0.7)
                
                if currentIndex > 0 {
                    Button(action: {
                        currentIndex = currentIndex-1
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: panjangBox/6)
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.8))
                    }.position(x:panjangBox/5*2,y: (fullGeometry.size.height)/2)
                    
                }
                
                
                // Tombol kanan hanya ditampilkan jika currentIndex < pages
                if currentIndex <  pages {
                    Button(action: {
                        currentIndex = currentIndex+1
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: panjangBox/6)
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.8))
                        
                    }
                    .position(x:fullGeometry.size.width-panjangBox/5*2,y: (fullGeometry.size.height)/2)
                }
                
                ZStack{
                    Image("wallet").resizable()
                        .scaledToFit()
                    HStack{
                        Image("gold").resizable().scaledToFit()
                            .frame(width:panjangBox/6)
                        Spacer()
                        WalletView()
                    }.padding(.horizontal,30)
                }.frame(width: panjangBox)
                    .position(x:fullGeometry.size.width-panjangBox,y:panjangBox/6)
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
            }
            
            
            
        }
        .onAppear(){
            initializeBuyerData()
        }
    }
    
    //    private func initializeBuyerData() {
    //            // Cek apakah sudah ada data tersimpan
    //            let buyers = loadBuyerData()
    //            if buyers.isEmpty {
    //                // Inisialisasi data awal jika belum ada
    //                var buyerData: [BuyerData] = Array(repeating: BuyerData(orders: [], goldEarned: 0), count: 3)
    //                for index in buyerData.indices {
    //                    buyerData[index].orders = [BuyerOrder(items: ["1": 2, "2": 1])]
    //                }
    //                saveBuyerData(buyerData)
    //            }
    //        }
    private func initializeBuyerData() {
        print("Initialize")
        buyers = loadBuyerData()
        if buyers.isEmpty {
            // Inisialisasi data awal
            var buyerData: [BuyerData] = Array(repeating: BuyerData(orders: [], goldEarned: 0), count: 3)
            for index in buyerData.indices {
                buyerData[index].orders = [BuyerOrder(items: ["1": 2, "2": 1])]
            }
            saveBuyerData(buyerData)
            buyers = buyerData
        }
        else{
            
            
            for index in buyers.indices{
                buyers[index].orders=[createNewOrder()]
            }
        }
        print("Initialize Kelar")
    }
    
    func imagePath(for idItem: String) -> String {
        if let item = items.first(where: { $0.id_item == idItem }) {
            return item.image_path ?? "defaultImage"
        } else {
            return "defaultImage" // Nama gambar default jika item tidak ditemukan
        }
       
    }

    
}


struct WalletView: View {
    @AppStorage("walletBalance") var walletBalance: Int = 0

    var body: some View {
        Text("\(walletBalance)")
            .font(.title) // Ganti "YourFontName" dengan nama font yang Anda inginkan
            .foregroundColor(.white)
            .shadow(color: .black, radius: 1, x: 0, y: 1) // Tambahkan bayangan untuk meningkatkan kontras
            .padding()
//            .background(Color.blue) // Background biru sebagai contoh
            .cornerRadius(10)
    }
}


struct OrderView: View {
    @Binding var buyers: [BuyerData]
    var index: Int  // Index buyer yang spesifik
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: []
    ) var items: FetchedResults<Item>
    var body: some View {
        VStack {
            if let firstOrder = buyers[index].orders.first {
                HStack {
                    ForEach(firstOrder.items.sorted(by: >), id: \.key) { key, value in
                        if let imagePath = findImagePath(for: key) {
                            HStack (spacing:0){
                                Image(imagePath) // Pastikan imagePath sesuai dengan nama di Assets
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("X\(value)")
                            }
                        }
                    }
                }
            }
        }
    }
    func findImagePath(for id: String) -> String? {
        items.first(where: { $0.id_item == id })?.image_path
    }
}

//struct OrderView: View {
//    @Binding var buyers: [BuyerData]
//    @FetchRequest(
//        entity: Item.entity(),
//        sortDescriptors: []
//    ) var items: FetchedResults<Item>
//
//    var body: some View {
//        VStack {
//            ForEach(buyers.indices, id: \.self) { index in
//                if let firstOrder = buyers[index].orders.first {
//                    HStack {
//                        ForEach(firstOrder.items.sorted(by: >), id: \.key) { key, value in
//                            if let imagePath = findImagePath(for: key) {
//                                HStack {
//                                    Image(imagePath) // Pastikan imagePath sesuai dengan nama di Assets
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                    Text("X \(value)")
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//    }
//
//    // Fungsi untuk mencari imagePath berdasarkan id_item
//    func findImagePath(for id: String) -> String? {
//        items.first(where: { $0.id_item == id })?.image_path
//    }
//}



//#Preview {
//    @State  var displayMode: DisplayMode = .shop
//    @State  var isMusicPlaying: Bool = true
//    Shop(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

struct Shop_Preview: PreviewProvider {
    @State static var displayMode: DisplayMode = .shop
    @State static var isMusicPlaying: Bool = true

    static var previews: some View {
        Shop(isMusicPlaying: $isMusicPlaying, displayMode: $displayMode).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct pageDalemView: View {
    @Binding var currentIndex: Int
    @State var panjangBox: CGFloat
    @State var fullGeometry: GeometryProxy
    @Binding var draggingItem: Item?
    @Binding var dragState: DragState // Tambahkan ini

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var inventoryItems: FetchedResults<Item>
   
    var body: some View {
        let indexnya = currentIndex * 8

        ZStack {
            // Pengaturan lainnya jika diperlukan...

            // Loop untuk baris pertama
            HStack(spacing: 0) {
                ForEach(indexnya..<(indexnya + 4), id: \.self) { index in
                    if index < inventoryItems.count {
                        let item = inventoryItems[index]
                        itemBoxView(item: item, panjangBox: panjangBox)
                    }
                    else {
                        EmptyBoxView(panjangBox: panjangBox)
                    }
                }
            }
            .position(x: fullGeometry.size.width/2, y: fullGeometry.size.height * 0.82 / 2)

            // Loop untuk baris kedua
            if indexnya+4<inventoryItems.count {
                HStack(spacing: 0) {
                    ForEach((indexnya + 4)..<(indexnya + 8), id: \.self) { index in
                        if index < inventoryItems.count {
                            let item = inventoryItems[index]
                            itemBoxView(item: item, panjangBox: panjangBox)
                        }
                        else {
                            EmptyBoxView(panjangBox: panjangBox)
                        }
                    }
                }
                .position(x: fullGeometry.size.width/2, y: fullGeometry.size.height * 1.17 / 2)
            }
        }
    }

    @ViewBuilder
    private func itemBoxView(item: Item, panjangBox: CGFloat) -> some View {
        var itemCount: Int {
                let count = ceil(sqrt(Double(item.count)))
                return count.isNaN || count.isInfinite ? 0 : Int(count)
            }
//        var item = Item // Ganti dengan item data Anda yang memiliki properti count
//        var÷itemCount: Int{return Double(item.count).isNaN || Double(item.count).isInfinite ? 0 : Int(item.count)}
        ZStack {
            Image("box-jual")
                .resizable()
                .scaledToFit()
                .opacity(1)

            VStack(spacing: -40) {
                // Baris pertama
                Text("\(max(0, Int(item.count)))")
                Spacer()
                HStack(spacing: -panjangBox * 0.01) {
                    ForEach(0..<min(5, max(0, Int(itemCount))), id: \.self) { _ in
                        Image(item.image_path ?? "telur")
                            
                            .resizable()
                            .scaledToFit()
                            .frame(width: panjangBox / 5)
                            .contentShape(Rectangle()) // Memastikan seluruh area bisa di-drag
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                self.dragState.isDragging = true
                                                self.dragState.draggedItem = item
                                                self.dragState.dragPosition = gesture.location
                                            }
                                            .onEnded { _ in
                                                self.dragState.isDragging = false
                                            }
                                    )
                                    .onDrag {
                                        self.draggingItem = item // Simpan referensi ke item yang di-drag
                                        let itemProvider = NSItemProvider()
                                        itemProvider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier, visibility: .all) {
                                            do {
                                                // Misalnya, gunakan `id` sebagai identifier
                                                if let id = item.id_item {
                                                    let data = "\(id)".data(using: .utf8)
                                                    $0(data, nil)
                                                } else {
                                                    throw NSError(domain: "com.yourdomain.error", code: -1, userInfo: nil)
                                                }
                                            } catch {
                                                $0(nil, error)
                                            }
                                            return nil
                                        }
                                        return itemProvider
                                    }

                            
                    }
                    Spacer()
                }
                .padding(.leading, panjangBox * 0.04)
                .frame(width: panjangBox)
                Spacer()
                // Baris kedua, jika diperlukan
                if itemCount > 5 {
                    HStack(spacing: -panjangBox * 0.01) {
                        ForEach(5..<Int(itemCount), id: \.self) { _ in
                            Image(item.image_path ?? "")
                                .resizable()
                                .scaledToFit()
                                .frame(width: panjangBox / 5)
//                                .contentShape(Rectangle()) // Memastikan seluruh area bisa di-drag
                                        .gesture(
                                            DragGesture()
                                                .onChanged { gesture in
                                                    self.dragState.isDragging = true
                                                    self.dragState.draggedItem = item
                                                    self.dragState.dragPosition = gesture.location
                                                }
                                                .onEnded { _ in
                                                    self.dragState.isDragging = false
                                                }
                                        )
                                        .onDrag {
                                            self.draggingItem = item // Simpan referensi ke item yang di-drag
                                            let itemProvider = NSItemProvider()
                                            itemProvider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier, visibility: .all) {
                                                do {
                                                    // Misalnya, gunakan `id` sebagai identifier
                                                    if let id = item.id_item {
                                                        let data = "\(id)".data(using: .utf8)
                                                        $0(data, nil)
                                                    } else {
                                                        throw NSError(domain: "com.yourdomain.error", code: -1, userInfo: nil)
                                                    }
                                                } catch {
                                                    $0(nil, error)
                                                }
                                                return nil
                                            }
                                            return itemProvider
                                        }
                        }
                        Spacer()
                    }
                    .padding(.leading, panjangBox * 0.04)
                    .frame(width: panjangBox)
                }
                else {
                        HStack(spacing: -panjangBox*0.01) {
                            
                                
                                Image("")                             .resizable()
                                    .scaledToFit()
                                    .frame(width: panjangBox/5)
                                
                            
                            
                            Spacer()
                        }
                        .padding(.leading,panjangBox*0.04).frame(width:panjangBox)
                        
                    
                }

//                Spacer()
            }
            .offset(CGSize(width: 0, height: -20.0))

            VStack {
                Spacer()
                Image("box-depan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: panjangBox)
//                    .overlay(
//                                        Rectangle().fill(Color.blue.opacity(0.5))
//                                        )
            }
        }
        .scaledToFit()
        .frame(width: panjangBox)
//        .overlay(
//                            Rectangle().fill(Color.blue.opacity(0.5))
//                            )
//        .gesture(
//        DragGesture()
//                                    .onChanged({ value in
//                                        print("b")
//                                    })
//        
//        )
        
        
    }
}

@ViewBuilder
private func EmptyBoxView(panjangBox: CGFloat) -> some View {
    ZStack {
        Image("box-jual")
            .resizable()
            .scaledToFit()
            .opacity(1)

      

        VStack {
            Spacer()
            Image("box-depan")
                .resizable()
                .scaledToFit()
                .frame(width: panjangBox)
        }
    }
    .scaledToFit()
    .frame(width: panjangBox)
}

struct DropAreaView: View {
    @Binding var buyers: [BuyerData]
    var index: Int
    @Binding var droppedItem: Item?
    @Binding var showCoin:Bool
    @Binding var coinPosition: CGFloat
    @Binding var coinOpacity: Double
    
    @AppStorage("walletBalance") var walletBalance: Int = 0
    @State var totalCount=0
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.5))
            .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                        providers.first?.loadObject(ofClass: String.self) { (droppedId, error) in
                            DispatchQueue.main.async {
                                if let droppedId = droppedId as? String, error == nil {
                                    processDrop(itemId: droppedId, forIndex: index)
                                }
                            }
                        }
                        return true
            }
    }
    private func processDrop(itemId: String, forIndex index: Int) {
        reduceItemCountInCoreData(itemId: itemId)
        if buyers.indices.contains(index), !buyers[index].orders.isEmpty {
            let firstOrder = buyers[index].orders[0]

            if let itemCount = firstOrder.items[itemId], itemCount > 0 {
                print("item ketemu")
                buyers[index].orders[0].items[itemId] = itemCount - 1
                // Kurangi count di Core Data model
//                           reduceItemCountInCoreData(itemId: itemId)
                // Periksa apakah semua item di order ini sudah 0
                if buyers[index].orders[0].items.values.allSatisfy({ $0 == 0 }) {
                    print("All items are 0, creating new order")
                    walletBalance += buyers[index].goldEarned
                        withAnimation(.easeInOut(duration: 2.0)) {
                            showCoin = true
                            coinPosition = 100 // Misalnya, dompet ada di offset -100 di sumbu Y
                            coinOpacity = 0
                        
                        // Setelah animasi selesai, reset state agar bisa digunakan lagi
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            showCoin = false
                            coinPosition = 0
                            coinOpacity = 1
                        }
                    }

                    // Tambahkan goldEarned ke buyer
                    buyers[index].goldEarned += calculateGold(for: firstOrder)
                    
                    // Buat order baru secara acak
                    buyers[index].orders[0] = createRandomOrder()
                   
                    buyers[index].goldEarned=totalCount
                }
                saveBuyerData(buyers)
            }
        }
    }
    private func reduceItemCountInCoreData(itemId: String) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id_item == %@", itemId)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let itemToReduce = results.first {
                itemToReduce.count -= 1  // Asumsikan Anda memiliki property `count` pada entitas `Item`
                try viewContext.save()
                print("ke db")
                
            }
        } catch let error as NSError {
            // Handle errors here
            print("Error reducing item count: \(error), \(error.userInfo)")
        }
    }

    func calculateGold(for order: BuyerOrder) -> Int {
        // Hitung goldEarned berdasarkan order, bisa disesuaikan
        return order.items.values.reduce(0, +) * 10 // Misal, setiap item bernilai 10 gold
    }

    func createRandomOrder() -> BuyerOrder {
        // Buat orderan baru dengan item secara random
        totalCount=0
        let itemsCount = Int.random(in: 1...4)
        var newOrderItems = [String: Int]()
        for _ in 0..<itemsCount {
            let itemId = "\(Int.random(in: 1...10))"
            newOrderItems[itemId] = Int.random(in: 1...5)
            totalCount += newOrderItems[itemId] ?? 0
        }
        
        return BuyerOrder(items: newOrderItems)
    }


}


//struct DropAreaView: View {
//    @Binding var buyers: [BuyerData]
//    var index: Int  // Index buyer yang spesifik
//    @Binding var droppedItem: Item?  // Item yang di-drop
//
//    var body: some View {
//        // Menampilkan area drop
//        Rectangle()
//            .foregroundColor(.gray.opacity(0.5))
//            .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
//                // Proses drop di sini
//                providers.first?.loadObject(ofClass: String.self) { (droppedId, error) in
//                    DispatchQueue.main.async {
//                        if let droppedId = droppedId as? String, error == nil {
//                            processDrop(itemId: droppedId)
//                        }
//                    }
//                }
//                return true
//            }
//    }
//
//    private func processDrop(itemId: String) {
//        // Update buyer[index] berdasarkan item yang di-drop
//        // ...
//    }
//}


//struct DropAreaView: View {
//    @Binding var buyers: [BuyerData]
//        @Binding var droppedItem: Item? // Misalkan ini adalah item yang di-drop
//
//        var body: some View {
//            // Menampilkan area drop
//            Rectangle()
//                .foregroundColor(.gray.opacity(0.5))
//                .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
//                    // Proses drop di sini
//                    providers.first?.loadObject(ofClass: String.self) { (droppedId, error) in
//                        DispatchQueue.main.async {
//                            if let droppedId = droppedId as? String, error == nil {
//                                processDrop(itemId: droppedId)
//                            }
//                        }
//                    }
//                    return true
//                }
//        }
//    private func processDrop(itemId: String) {
//        // Logika untuk mengurangi count dari item dan memperbarui orderan
//    
//    }
//    func checkAndProcessOrders() {
//        // Anda mungkin ingin memanggil ini setelah drag-and-drop selesai
//        var loadedBuyers = loadBuyerData()
//        for index in loadedBuyers.indices {
//            completeOrder(for: index, buyers: &loadedBuyers)
//        }
//    }
//
//}

struct DragState {
    var isDragging = false
    var draggedItem: Item?
    var dragPosition: CGPoint?
}
struct ItemDragView: View {
    let item: Item
    var dragPosition: CGPoint?

    var body: some View {
        Image(item.image_path ??  "telur")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .shadow(radius: 10) // Tambahkan sedikit bayangan untuk efek mengangkat
    }
}

struct BuyerOrder: Codable {
    var items: [String: Int]
//    var totalGoldReward: Int
}

struct BuyerData: Codable {
    var orders: [BuyerOrder]
    var goldEarned: Int
}

func saveBuyerData(_ buyers: [BuyerData]) {
    if let encoded = try? JSONEncoder().encode(buyers) {
        UserDefaults.standard.set(encoded, forKey: "buyerData")
        print("Data saved: \(buyers)")
    } else {
        print("Failed to encode data")
    }
}

func loadBuyerData() -> [BuyerData] {
    if let savedData = UserDefaults.standard.data(forKey: "buyerData"),
       let loadedData = try? JSONDecoder().decode([BuyerData].self, from: savedData) {
        print("Loaded data: \(loadedData)")
        return loadedData
    }
    print("No saved data, returning empty array")
    return [] // Kembali ke state default jika tidak ada data
}

func processDrop(itemId: String, for buyerOrder: inout BuyerOrder) {
    if let quantity = buyerOrder.items[itemId], quantity > 0 {
        buyerOrder.items[itemId] = quantity - 1
    }
}
func completeOrder(for buyerIndex: Int, buyers: inout [BuyerData]) {
    guard buyers.indices.contains(buyerIndex),
          let order = buyers[buyerIndex].orders.first(where: { $0.items.values.allSatisfy { $0 == 0 } }) else {
        return
    }

    // Memberikan gold dan membuat orderan baru
    let goldEarned = buyers[buyerIndex].goldEarned
    buyers[buyerIndex].goldEarned = goldEarned + calculateGoldReward(for: order)
    buyers[buyerIndex].orders = [createNewOrder()]
}

func calculateGoldReward(for order: BuyerOrder) -> Int {
    // Hitung gold reward berdasarkan order
    // Misal, setiap item memberikan 5 gold
    return order.items.reduce(0) { $0 + $1.value * 5 }
}
func createNewOrder() -> BuyerOrder {
    // Buat orderan baru dengan item secara random
    let itemsCount = Int.random(in: 1...4)
    var newOrderItems = [String: Int]()
    for _ in 0..<itemsCount {
        let itemId = "\(Int.random(in: 1...10))"
        newOrderItems[itemId] = Int.random(in: 1...5)
    }
    return BuyerOrder(items: newOrderItems)
}
func checkAndProcessOrders() {
    var buyers = loadBuyerData()
    for index in buyers.indices {
        completeOrder(for: index, buyers: &buyers)
    }
    saveBuyerData(buyers)
}
