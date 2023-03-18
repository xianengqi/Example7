//
//  AddProductView.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/18.
//

import SwiftUI

struct AddProductView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) private var managedObjectContext

  @State private var selectedColors: [String] = []
  @State private var selectedSizes: [String] = []
  @State var showColor = false
  @State var showSize = false

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
//        TextField("颜色（用逗号分隔）", text: $colors)
        formColorView().frame(height: 20)
//        TextField("尺码（用逗号分隔）", text: $sizes)

        formSizeView().frame(height: 20)
      }

      Button(action: {
        saveNewProduct()
      }) {
        Text("添加商品")
      }
    }
    .navigationBarTitle("添加商品", displayMode: .inline)
  }

  func saveNewProduct() {
//    let colorList = colors.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
//    let sizeList = sizes.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        let colorList = selectedColors
        let sizeList = selectedSizes
    let newSpu = SpuEntity(context: managedObjectContext)
    newSpu.id = UUID()
    newSpu.name = productName
    newSpu.price = Double(productPrice) ?? 0

//    let newSku = SkuEntity(context: managedObjectContext)
//    newSku.id = UUID()
//    newSku.color = selectedColors.joined(separator: " ")
//    newSku.size = selectedSizes.joined(separator: " ")
//    newSku.stock = 0
//    newSku.spu = newSpu

    for color in colorList {
      for size in sizeList {
        let newSku = SkuEntity(context: managedObjectContext)
        newSku.id = UUID()
        newSku.color = color
        newSku.size = size
        newSku.stock = 0
        newSku.spu = newSpu
      }
    }

    do {
      try managedObjectContext.save()
      presentationMode.wrappedValue.dismiss()
    } catch {
      print("Error saving new product: \(error)")
    }
  }

  @ViewBuilder
  func formColorView() -> some View {
    HStack {
      Color.clear.overlay {
        Text("颜色")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(width: 40)

      Color.clear.overlay {
        Text(selectedColors.isEmpty ? "选择颜色" : "\(selectedColors.joined(separator: ", "))")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }.frame(width: 10)
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      print("点击弹出Sheet")
      // 在打开Sheet之前先将已选中的颜色状态清空
      selectedColors = []
      showColor = true
//      let isSelected = selectedColors.contains(color.colors)
//      isSelected = false
      // 清空选中的颜色状态
//      selectedColors.removeAll()
    }

    .sheet(isPresented: $showColor) {
      ColorExample(selectedColors: $selectedColors)
        .onAppear {
          // 清空选中的颜色状态

          selectedColors.removeAll()
          // 把 isSelected状态设置为flase
        }
//        .environment(\.managedObjectContext, viewContext)

        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }
  }

  @ViewBuilder
  func formSizeView() -> some View {
    HStack {
      Color.clear.overlay {
        Text("尺码")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }.frame(width: 40)

      Color.clear.overlay {
        Text(selectedSizes.isEmpty ? "选择尺码" : "\(selectedSizes.joined(separator: ", "))")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }.frame(width: 10)
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      showSize = true
    }

    .sheet(isPresented: $showSize) {
      SizeExample(selectedColors: $selectedSizes)
        .onAppear {
          // 清空选中的颜色状态

          selectedSizes.removeAll()
          // 把 isSelected状态设置为flase
        }
        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }
  }
}

struct AddProductView_Previews: PreviewProvider {
  static var previews: some View {
    AddProductView()
  }
}
