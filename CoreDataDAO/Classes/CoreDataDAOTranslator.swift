//
//  CoreDataDAOTranslator.swift
//  Pods
//
//  Created by Mikhail Zinov on 18/02/2017.
//
//

import Foundation
import CoreData

class CoreDataDAOTranslator<EntityType, EntryType> {
    
    public init() {}
    
    open func toEntity(entry: EntryType) throws -> EntityType? {
        throw DAOError.subclassOverrideNecessary
    }
    
    open func toEntry(entity: EntityType, context: NSManagedObjectContext) throws -> EntryType {
        throw DAOError.subclassOverrideNecessary
    }
    
    open func toEntries(entities: [EntityType], context: NSManagedObjectContext) -> [EntryType] {
        return entities.map { try! self.toEntry(entity: $0,
                                                context: context)
        }
    }
    
    open func toEntities(entries: [EntryType]) -> [EntityType] {
        return entries.map { try! self.toEntity(entry: $0)!
        }
    }
}

enum DAOError: Error {
    case subclassOverrideNecessary
}

