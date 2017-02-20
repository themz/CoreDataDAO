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

class CDEntry: NSManagedObject {
    @NSManaged var id: String
}
