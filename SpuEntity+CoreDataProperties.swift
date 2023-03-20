//
//  SpuEntity+CoreDataProperties.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/18.
//
//

import CoreData
import Foundation

public extension SpuEntity {
  @nonobjc class func fetchRequest() -> NSFetchRequest<SpuEntity> {
    return NSFetchRequest<SpuEntity>(entityName: "SpuEntity")
  }

  @NSManaged var id: UUID
  @NSManaged var name: String
  @NSManaged var price: Double
  @NSManaged var skus: Set<SkuEntity>
}

// MARK: Generated accessors for skus

public extension SpuEntity {
  @objc(addSkusObject:)
  @NSManaged func addToSkus(_ value: SkuEntity)

  @objc(removeSkusObject:)
  @NSManaged func removeFromSkus(_ value: SkuEntity)

  @objc(addSkus:)
  @NSManaged func addToSkus(_ values: NSSet)

  @objc(removeSkus:)
  @NSManaged func removeFromSkus(_ values: NSSet)
}

extension SpuEntity: Identifiable {}

extension SpuEntity {
  var totalStock: Int16 {
    var sum = 0
    for sku in skus {
      sum += Int(sku.stock)
    }
    return Int16(sum)
  }
}

extension SpuEntity {
  var colorStocks: [String: Int16] {
    let skusByColor = Dictionary(grouping: skus, by: { $0.color })
    return skusByColor.reduce(into: [:]) { result, pair in
      result[pair.key] = pair.value.reduce(0) { $0 + $1.stock }
    }
  }
}
