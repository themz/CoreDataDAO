//
//  CoreDataDAO.swift
//  Pods
//
//  Created by Mikhail Zinov on 18/02/2017.
//
//

import Foundation
import CoreData

class CoreDataDAO<Entity, Entry: CDEntry> {
    private let translator: CoreDataDAOTranslator<Entity, Entry>
    
    /// Core Data стек
    private var managedObjectModel: NSManagedObjectModel
    private var coordinator: NSPersistentStoreCoordinator
    private var context: NSManagedObjectContext
    /**
     Инициализатор DAO
     
     - Parameter translator: Транслятор для преобразования обьектных моделей
     в модели базы данных
     - Parameter managedObjectModelName: Название файла .xcdatamodeld
     после компиляции преобразованного в .mom
     
     - Returns: Реализация DAO для конкретного сервиса
     
     - Important: Класс Entry должен быть наследником NSManagedObject
     
     - Todo: Доделать инициализацию окружения. Переделать под ios 10 c NSPersistentContainer. Обработать возможные ошибки, сейчас максимальный fast-fail.
     */
    public init(translator: CoreDataDAOTranslator<Entity, Entry>,
                managedObjectModelName: String) {
        self.translator = translator
        
        //
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentsDirectory = urls[urls.count - 1] as NSURL
        
        // NSManagedObjectModel
        let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd")!
        self.managedObjectModel  = NSManagedObjectModel(contentsOf: modelURL)!
        
        // NSPersistentStoreCoordinator
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(managedObjectModelName)
        try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        
        // NSManagedObjectContext
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coordinator
    }
    
    /**
     Метод для сохранения сущности Entity
     
     - Parameter entity: Сущность типа Entity для сохранения
     
     - Returns: Флаг Bool: true - сохранение прошло успешно, false - ошибка сохранения
     */
    public func persist(_ entity: Entity) -> Bool {
        _ = try! self.translator.toEntry(entity: entity,
                                         context: self.context)
        return saveContext()
    }
    
    /**
     Метод для сохранения массива [Entity]
     
     - Parameter entities: Массив cущностей [Entity] для сохранения
     
     - Returns: Флаг Bool: true - сохранение прошло успешно, false - ошибка сохранения
     */
    public func persist(_ entities: [Entity]) -> Bool {
        _ = self.translator.toEntries(entities: entities,
                                      context: self.context)
        return saveContext()
    }
    
    /**
     Метод получения сущности типа Entity по идентификатору
     
     - Parameter id: Иднентификатор сущности Entity
     
     - Returns: Сущность типа Entity, либо nil, если сущность не найдена в БД
     */
    public func read(id: String) -> Entity? {
        let fetchRequest =  NSFetchRequest<Entry>(entityName: String(describing: Entry.self)) as! NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        if let entry = try! context.fetch(fetchRequest).first as? Entry {
            return try! translator.toEntity(entry: entry)
        }
        
        return nil
    }
    
    /**
     Метод получения всех сущностей типа Entity
     
     - Returns: Массив обьектов типа Entity, либо пустой массив, если сущности не найдена в БД
     */
    public func read() -> [Entity] {
        let fetchRequest =  NSFetchRequest<Entry>(entityName: String(describing: Entry.self)) as! NSFetchRequest<NSFetchRequestResult>
        let entries = try! context.fetch(fetchRequest) as! [Entry]
        
        return translator.toEntities(entries: entries)
    }
    
    /**
     Метод для удаления сущности Entity
     
     - Parameter id: Иднентификатор сущности Entity
     
     - Returns: Флаг Bool: true - удаление прошло успешно, false - ошибка удаления
     */
    public func erase(id: String) -> Bool {
        let fetchRequest =  NSFetchRequest<Entry>(entityName: String(describing: Entry.self)) as! NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        return self.erace(fetchRequest)
    }
    
    /**
     Метод для удаления всех сущностей типа Entity
     
     - Returns: Флаг Bool: true - удаление прошло успешно, false - ошибка удаления
     */
    public func erase() -> Bool {
        return self.erace(NSFetchRequest<Entry>(entityName: String(describing: Entry.self)) as! NSFetchRequest<NSFetchRequestResult>)
    }
    
    // MARK: - Приватные методы
    
    private func erace(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> Bool {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context.execute(deleteRequest)
            return true
        } catch {
            return false
        }
    }
    
    private func saveContext () -> Bool {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                return false
            }
        }
        return true
    }
}
