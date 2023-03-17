import SwiftUI

struct Spu: Identifiable {
    let id = UUID() // 添加 id 属性，使 Spu 遵循 Identifiable 协议
    let name: String
    let price: Double
  var skus: [Sku]
}

struct Sku: Identifiable {
    let id = UUID()
    let color: String
    let size: String
    var stock: Int
}

struct ContentView: View {
  @State private var selectedColor: String?
  @State private var spu = Spu(name: "Demo", price: 100, skus: [
    Sku(color: "米白", size: "S", stock: 10),
    Sku(color: "米白", size: "M", stock: 12),
    Sku(color: "米白", size: "L", stock: 16),
    Sku(color: "卡其", size: "S", stock: 8),
    Sku(color: "卡其", size: "M", stock: 14),
    Sku(color: "卡其", size: "L", stock: 18),
  ])

  var body: some View {
    VStack {
      Text(spu.name).font(.title)
      HStack {
        ForEach(Array(Set(spu.skus.map { $0.color })).sorted(), id: \.self) { color in
            Button(action: {
                selectedColor = color
            }) {
                Text(color)
            }
            .padding()
        }

      }
      if let selectedColor = selectedColor {
        ForEach(spu.skus.filter { $0.color == selectedColor }, id: \.size) { sku in
          HStack {
            Text("\(sku.size): \(sku.stock) 件")
            Button("入库") {
              if let index = spu.skus.firstIndex(where: { $0.color == selectedColor && $0.size == sku.size }) {
                spu.skus[index].stock += 1
              }
            }
            .padding()
            Button("出库") {
              if let index = spu.skus.firstIndex(where: { $0.color == selectedColor && $0.size == sku.size }) {
                spu.skus[index].stock -= 1
              }
            }
            .padding()
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
