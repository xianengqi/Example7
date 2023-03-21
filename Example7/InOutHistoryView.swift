import SwiftUI

struct InOutHistoryView: View {
  @ObservedObject var sku: SkuEntity

  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()

  var body: some View {
    List {
      Section(header: Text("\(sku.color) - \(sku.size)")) {
        ForEach(Array(sku.inStockHistories).sorted { $0.timestamp > $1.timestamp }, id: \.self) { history in
          HStack {
            Text("\(history.timestamp, formatter: dateFormatter)")
            Spacer()
            Text("+\(history.quantity)")
          }
        }

        ForEach(Array(sku.outStockHistories).sorted { $0.timestamp > $1.timestamp }, id: \.self) { history in
          HStack {
            Text("\(history.timestamp, formatter: dateFormatter)")
            Spacer()
            Text("-\(history.quantity)")
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("入库/出库历史记录", displayMode: .inline)
  }
}
