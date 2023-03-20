//
//  OutStockHistory+CoreDataProperties.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/20.
//
//

import Foundation
import CoreData


extension OutStockHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OutStockHistory> {
        return NSFetchRequest<OutStockHistory>(entityName: "OutStockHistory")
    }

    @NSManaged public var timestamp: Date
    @NSManaged public var quantity: Int32
    @NSManaged public var sku: SkuEntity

}

extension OutStockHistory : Identifiable {

}
