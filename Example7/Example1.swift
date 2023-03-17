//
//  Example1.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/17.
//

import SwiftUI

// 商品列表页面
struct ProductListView: View {
  @State private var products: [Spu] = [
    Spu(name: "T-shirt", price: 100, skus: [
      Sku(color: "米白", size: "S", stock: 10),
      Sku(color: "米白", size: "M", stock: 12),
      Sku(color: "米白", size: "L", stock: 16),
      Sku(color: "卡其", size: "S", stock: 8),
      Sku(color: "卡其", size: "M", stock: 14),
      Sku(color: "卡其", size: "L", stock: 18),
    ]),
  ]

  var body: some View {
    NavigationView {
      List(products) { product in
        NavigationLink(destination: ProductDetailView(spu: product)) {
          VStack(alignment: .leading) {
            Text(product.name)
              .font(.headline)
            Text("价格: \(product.price, specifier: "%.2f")")
              .font(.subheadline)
          }
        }
        .navigationBarTitle("商品列表")
        .navigationBarItems(trailing:
          NavigationLink(destination: AddProductView(products: $products)) {
            Image(systemName: "plus")
          }
        )
      }
    }
  }
}

// 商品详情页面
struct ProductDetailView: View {
  @State var spu: Spu

  var body: some View {
    VStack {
      List {
        Section(header: Text("基本信息")) {
          Text("商品名称：\(spu.name)")
          Text("价格：\(spu.price, specifier: "%.2f")")
        }

        VStack {
          Text("库存信息")
          StockDetailsView(spu: $spu)
          
//          ForEach(Array(Set(spu.skus.map { $0.color })).sorted(), id: \.self) { color in
//            NavigationLink(destination: StockDetailsView(spu: $spu)) {
//              Text(color)
//            }
//
//          }
        }
       
      }
      .listStyle(InsetGroupedListStyle())
    }
    .navigationBarTitle(Text(spu.name), displayMode: .inline)
  }
}

// 库存详情页面
struct StockDetailsView: View {
  @Binding var spu: Spu
  @State private var selectedColor: String = ""

  var body: some View {
    VStack {
      Text("选择颜色")
        .font(.headline)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(Array(Set(spu.skus.map { $0.color })).sorted(), id: \.self) { color in
            Button(action: {
              selectedColor = color
            }) {
              Text(color)
                .padding()
//                .background(selectedColor == color ? Color.red.frame(width: 2, height: 2).border(Color.red, width: 1) : Color.clear)
            }
          }
        }
      }
      .padding(.bottom)
      if !selectedColor.isEmpty {
        Text("库存详情 (\(selectedColor))")
          .font(.headline)
          .padding(.top)

        VStack {
          ForEach(spu.skus.filter { $0.color == selectedColor }) { sku in
            HStack {
              Text("尺寸：\(sku.size)")
              Spacer()
              Text("库存：\(sku.stock)")

              Button(action: {
                if let index = spu.skus.firstIndex(where: { $0.id == sku.id }) {
                  spu.skus[index].stock += 1
                }
              }) {
                Image(systemName: "plus.circle")
                  .foregroundColor(.green)
              }
              .buttonStyle(BorderlessButtonStyle())

              Button(action: {
                if let index = spu.skus.firstIndex(where: { $0.id == sku.id }) {
                  spu.skus[index].stock = max(0, spu.skus[index].stock - 1)
                }
              }) {
                Image(systemName: "minus.circle")
                  .foregroundColor(.red)
              }
              .buttonStyle(BorderlessButtonStyle())
            }
            
          }
        }
//        .frame(height: 700)
      }
    }
    .padding(.horizontal)
    .navigationBarTitle("库存详情", displayMode: .inline)
  }
}

// 添加商品页面
struct AddProductView: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var products: [Spu]

  @State private var productName = ""
  @State private var productPrice = ""
  @State private var colors = ""
  @State private var sizes = ""

  var body: some View {
    Form {
      Section(header: Text("基本信息")) {
        TextField("商品名称", text: $productName)
        TextField("商品价格", text: $productPrice)
      }

      Section(header: Text("颜色和尺码")) {
        TextField("颜色（用逗号分隔）", text: $colors)
        TextField("尺码（用逗号分隔）", text: $sizes)
      }

      Button(action: {
        let colorList = colors.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        let sizeList = sizes.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }

        var skus: [Sku] = []
        for color in colorList {
          for size in sizeList {
            skus.append(Sku(color: color, size: size, stock: 0))
          }
        }

        let newSpu = Spu(name: productName, price: Double(productPrice) ?? 0, skus: skus)
        products.append(newSpu)

        presentationMode.wrappedValue.dismiss()
      }) {
        Text("添加商品")
      }
    }
    .navigationBarTitle("添加商品", displayMode: .inline)
  }
}

struct Example1: View {
  var body: some View {
    ProductListView()
  }
}

struct Example1_Previews: PreviewProvider {
  static var previews: some View {
    Example1()
  }
}
