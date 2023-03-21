import SwiftUI

struct InOutHistoryView: View {
  var skus: [SkuEntity]

  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()

  var body: some View {
    List {
      ForEach(skus.sorted { $0.size > $1.size }, id: \.self) { sku in
        Section(header: Text("\(sku.color) - \(sku.size)")) {
          ForEach(Array(sku.inStockHistories).sorted { $0.timestamp > $1.timestamp }, id: \.self) { history in
            HStack {
              Text("\(history.timestamp, formatter: dateFormatter)")
              Spacer()
              Text("入库\(history.quantity)")
            }
          }

          ForEach(Array(sku.outStockHistories).sorted { $0.timestamp > $1.timestamp }, id: \.self) { history in
            HStack {
              Text("\(history.timestamp, formatter: dateFormatter)")
              Spacer()
              Text("出库\(history.quantity)")
            }
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("入库/出库历史记录", displayMode: .inline)
  }
}
