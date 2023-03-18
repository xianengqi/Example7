//
//  SkuEntity+CoreDataProperties.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/18.
//
//

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

  @NSManaged var spu: SpuEntity

//  override func awakeFromInsert() {
//    super.awakeFromInsert()
//    id = UUID()
//    sortIndex = Int16(Date().timeIntervalSince1970) // 为 sortIndex 赋值
//  }
}

extension SkuEntity: Identifiable {}
