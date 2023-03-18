//
//  Example2.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/18.
//

// ProductListView.swift
import Combine
import CoreData
import SwiftUI

struct ProductListView: View {
  @Environment(\.managedObjectContext) private var managedObjectContext
  @FetchRequest(entity: SpuEntity.entity(), sortDescriptors: []) private var products: FetchedResults<SpuEntity>

  @State private var showDeleteAlert = false
  @State private var deletingProduct: SpuEntity? // the product to be deleted

  var body: some View {
    NavigationView {
      List {
        ForEach(products) { product in
          NavigationLink(destination: ProductDetailView(spu: product)) {
            VStack(alignment: .leading) {
              Text(product.name)
                .font(.headline)
              Text("价格: \(product.price, specifier: "%.2f")")
                .font(.subheadline)
            }
          }
        }
        .onDelete { indexSet in
          if let index = indexSet.first {
            deletingProduct = products[index]
            showDeleteAlert = true
          }
        }
      }
      .navigationBarTitle("商品列表")
      .navigationBarItems(trailing:
        NavigationLink(destination: AddProductView()) {
          Image(systemName: "plus")
        }
      )
      .alert(isPresented: $showDeleteAlert) {
        Alert(
          title: Text("确认删除商品？"),
          message: Text("删除后无法恢复！"),
          primaryButton: .destructive(Text("删除"), action: deleteProduct),
          secondaryButton: .cancel()
        )
      }
    }
  }

  func deleteProduct() {
    if let product = deletingProduct {
      managedObjectContext.delete(product)
      do {
        try managedObjectContext.save()
      } catch {
        print("Error deleting product: \(error)")
      }
    }
    deletingProduct = nil
  }
}

// ProductDetailView.swift
struct ProductDetailView: View {
  @ObservedObject var spu: SpuEntity

  @Environment(\.managedObjectContext) private var managedObjectContext
  @Environment(\.presentationMode) var presentationMode

  @State private var showingDeleteAlert = false

  var body: some View {
    VStack {
      List {
        Section(header: Text("基本信息")) {
          Text("商品名称：\(spu.name)")
          Text("价格：\(spu.price, specifier: "%.2f")")
        }

        VStack {
          Text("库存信息")
          StockDetailsView(spu: spu)
        }
      }
      .listStyle(InsetGroupedListStyle())
    }
    .navigationBarTitle(Text(spu.name), displayMode: .inline)
  }
}

// 库存详情页面
struct StockDetailsView: View {
  @ObservedObject var spu: SpuEntity

  @State private var selectedColor: String?
  @State private var selectedSku: SkuEntity?

  @Environment(\.managedObjectContext) private var managedObjectContext

  @State private var updateView: Bool = false // Add this line

  init(spu: SpuEntity) {
    self.spu = spu
    self._selectedColor = State(initialValue: Array(Set(spu.skus.map { $0.color })).sorted().first)
    self._selectedSku = State(initialValue: spu.skus.filter { $0.color == self.selectedColor }.first)
  }

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
            }
          }
        }
      }
      .padding(.bottom)
      if let selectedColor = selectedColor, !selectedColor.isEmpty {
        Text("库存详情 (\(selectedColor))")
          .font(.headline)
          .padding(.top)

        VStack {
          ForEach(spu.skus.filter { $0.color == selectedColor }.sorted { $0.size > $1.size }) { sku in
            HStack {
              Text("尺寸：\(sku.size)")
              Spacer()
              Text("库存：\(sku.stock)")

              Button(action: {
                sku.stock += 1
                updateView.toggle() // Add this line
                try? managedObjectContext.save()
              }) {
                Image(systemName: "plus.circle")
                  .foregroundColor(.green)
              }
              .buttonStyle(BorderlessButtonStyle())

              Button(action: {
                sku.stock = max(0, sku.stock - 1)
                updateView.toggle() // Add this line
                try? managedObjectContext.save()
              }) {
                Image(systemName: "minus.circle")
                  .foregroundColor(.red)
              }
              .buttonStyle(BorderlessButtonStyle())
            }
          }
        }
      }
    }
    .onReceive(Just(updateView)) { _ in
      // Do nothing, but trigger the view update
    }
    .padding(.horizontal)
    .navigationBarTitle("库存详情", displayMode: .inline)
  }
}

// 添加商品页面
import SwiftUI



struct Example2: View {
  var body: some View {
    ProductListView()
  }
}

struct Example2_Previews: PreviewProvider {
  static var previews: some View {
    Example2()
  }
}
