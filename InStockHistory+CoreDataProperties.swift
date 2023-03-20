//
//  InStockHistory+CoreDataProperties.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/20.
//
//

import Foundation
import CoreData


extension InStockHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InStockHistory> {
        return NSFetchRequest<InStockHistory>(entityName: "InStockHistory")
    }

    @NSManaged public var timestamp: Date
    @NSManaged public var quantity: Int32
    @NSManaged public var sku: SkuEntity

}

extension InStockHistory : Identifiable {

}
