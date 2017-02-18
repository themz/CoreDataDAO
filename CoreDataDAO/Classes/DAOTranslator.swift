//
//  DAOTranslator.swift
//  Vkusomaniya
//
//  Created by Mikhail Zinov on 13/02/2017.
//  Copyright © 2017 mz. All rights reserved.
//

import Foundation

/**
 Протокол для создания транслятора для преобразования модельных обьектов в сущности базы данных
 
 Entity - модельная сущность
 Entry - сущность в БД
 
 */
public protocol DAOTranslator {
    ///Определяем в классе или структуре
    associatedtype Entity
    associatedtype Entry
    
    /// Из модельного объекта в объект БД
    func toEntry(entity: Entity) throws -> Entry
    
    /// Из обьекта БД в модельный объекты
    func toEntity(entry: Entry) throws -> Entity
}

extension DAOTranslator {    
    func toEntries(entities: [Entity]) -> [Entry] {
        return entities.map { try! self.toEntry(entity: $0) }
    }
    
    func toEntities(entries: [Entry]) -> [Entity] {
        return entries.map { try! self.toEntity(entry: $0) }
    }
}

enum DAOError: Error {
    case subclassOverrideNecessary
}
