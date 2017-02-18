//
//  CoreDataDAO.swift
//  Pods
//
//  Created by Mikhail Zinov on 18/02/2017.
//
//

import Foundation
import CoreData

class CoreDataDAO<Entity, Entry: NSManagedObject>  {
    private let translator: CoreDataDAOTranslator<Entity, Entry>
    
    public init(translator: CoreDataDAOTranslator<Entity, Entry>) {
        self.translator = translator
    }
    
    public func persist(_ entity: Entity) -> Bool {
        return false
    }
    
    public func persist(_ entities: [Entity]) -> Bool {
        return false
    }
    
    public func read(id: String) -> Entity? {
        return nil
    }
    
    public func read() -> [Entity] {
        return []
    }
    
    public func erase(id: String) -> Bool {
        return false
    }
    
    public func erase() -> Bool {
        return false
    }
    
}
