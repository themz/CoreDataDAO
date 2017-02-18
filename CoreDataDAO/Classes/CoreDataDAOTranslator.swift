//
//  CoreDataDAOTranslator.swift
//  Pods
//
//  Created by Mikhail Zinov on 18/02/2017.
//
//

import Foundation
import CoreData

class CoreDataDAOTranslator<EntityType, EntryType: NSManagedObject>: DAOTranslator {
    public typealias Entity = EntityType
    public typealias Entry = EntryType
    
    public init() {}
    
    open func toEntity(entry: EntryType) throws -> EntityType {
        throw DAOError.subclassOverrideNecessary
    }
    
    open func toEntry(entity: EntityType) throws -> EntryType {
        throw DAOError.subclassOverrideNecessary
    }
}
