//
//  Entry.swift
//  Pods
//
//  Created by Mikhail Zinov on 18/02/2017.
//
//

import Foundation
import CoreData

@objc(CDEntry)

open class CDEntry: NSManagedObject {
    @NSManaged open var id: String
}
