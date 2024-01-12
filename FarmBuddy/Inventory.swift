import SwiftUI
import CoreData

struct InventoryView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var inventoryItems: FetchedResults<Item>

    @State var isPresented = false // Untuk mengontrol pop-up

    var body: some View {
        Button("Show Inventory") {
            self.isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            VStack {
                Text("Inventory")
                    .font(.largeTitle)
                    .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(inventoryItems, id: \.self) { item in
                            VStack {
                                Image(item.image_path ?? "placeholder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                    .overlay(Circle().stroke(Color.green, lineWidth: 3))

                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)

                                ProgressBar(value: item.count, maxValue: 100)
                                    .frame(height: 20)

                                Text("\(item.count)/100")
                                    .font(.caption)
                            }
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        }
                    }
                }.padding(.horizontal) // Menambahkan padding secara horizontal
                    .padding(.bottom, 10)
            }
            .padding(.top)
            .background(Color.yellow)
        }
    }
}

struct ProgressBar: View {
    var value: Int32
    var maxValue: Int32

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Rectangle().frame(width: min(CGFloat(self.value) / CGFloat(self.maxValue) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.blue)
                    .animation(.linear(duration: 0.6))
            }
            .cornerRadius(45.0)
        }
    }
}

// Preview
struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
