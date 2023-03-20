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
      Section(header: Text("入库历史")) {
        ForEach(Array(sku.inStockHistories).sorted { ($0 as! InStockHistory).timestamp > ($1 as! InStockHistory).timestamp }, id: \.self) { history in
          HStack {
            Text("\(history.timestamp, formatter: dateFormatter)")
            Spacer()
            Text("+\(history.quantity)")
          }
        }
      }

      Section(header: Text("出库历史")) {
        ForEach(Array(sku.outStockHistories).sorted { ($0 as! OutStockHistory).timestamp > ($1 as! OutStockHistory).timestamp }, id: \.self) { history in
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
