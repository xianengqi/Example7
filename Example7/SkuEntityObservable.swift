import CoreData
import Combine

//public class SkuEntityObservable: SkuEntity, ObservableObject {
//    @Published public override var stock: Int16 {
//        didSet {
//            if stock != oldValue {
//                self.objectWillChange.send()
//                self.willChangeValue(forKey: "stock")
//                self.setValue(stock, forKey: "stock")
//                self.didChangeValue(forKey: "stock")
//            }
//        }
//    }
//}

public class SkuEntityObservable: SkuEntity {
  @objc override public dynamic var stock: Int16 {
    didSet {
      if self.stock != oldValue {
        self.willChangeValue(forKey: "stock")
        self.setValue(self.stock, forKey: "stock")
        self.didChangeValue(forKey: "stock")
      }
    }
  }
}
