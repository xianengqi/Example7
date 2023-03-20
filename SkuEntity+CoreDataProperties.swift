//
//  SkuEntity+CoreDataProperties.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/18.
//
//

import Combine
import CoreData
import Foundation

public extension SkuEntity {
  @nonobjc class func fetchRequest() -> NSFetchRequest<SkuEntity> {
    return NSFetchRequest<SkuEntity>(entityName: "SkuEntity")
  }

  @NSManaged var id: UUID
  @NSManaged var color: String
  @NSManaged var size: String
  @NSManaged var stock: Int16
  @NSManaged var sortIndex: Int16 // 添加 sortIndex 属性

  @NSManaged var colorArray: [String]?
  @NSManaged var sizeArray: [String]?

  // 添加与入库和出库历史记录的关系
  @NSManaged var inStockHistories: Set<InStockHistory>
  @NSManaged var outStockHistories: Set<OutStockHistory>

  @NSManaged var spu: SpuEntity

  func removeFromColorArray(_ size: String) {
    if let index = colorArray!.firstIndex(of: size) {
      colorArray!.remove(at: index)
    }
  }
}

extension SkuEntity: Identifiable {}

public extension SkuEntity {
  // Convenience methods for handling Set<InStockHistory> and Set<OutStockHistory>
  func addToInStockHistories(_ value: InStockHistory) {
    inStockHistories.insert(value)
  }

  func removeFromInStockHistories(_ value: InStockHistory) {
    inStockHistories.remove(value)
  }

  func addToOutStockHistories(_ value: OutStockHistory) {
    outStockHistories.insert(value)
  }

  func removeFromOutStockHistories(_ value: OutStockHistory) {
    outStockHistories.remove(value)
  }
}
