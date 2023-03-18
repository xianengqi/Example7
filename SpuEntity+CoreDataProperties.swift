//
//  SpuEntity+CoreDataProperties.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/18.
//
//

import Foundation
import CoreData


extension SpuEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpuEntity> {
        return NSFetchRequest<SpuEntity>(entityName: "SpuEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var skus: Set<SkuEntity>

}

// MARK: Generated accessors for skus
extension SpuEntity {

    @objc(addSkusObject:)
    @NSManaged public func addToSkus(_ value: SkuEntity)

    @objc(removeSkusObject:)
    @NSManaged public func removeFromSkus(_ value: SkuEntity)

    @objc(addSkus:)
    @NSManaged public func addToSkus(_ values: NSSet)

    @objc(removeSkus:)
    @NSManaged public func removeFromSkus(_ values: NSSet)

}

extension SpuEntity : Identifiable {

}
