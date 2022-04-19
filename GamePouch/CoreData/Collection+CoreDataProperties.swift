import Foundation
import CoreData

extension Collection{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Collection> {
        return NSFetchRequest<Collection>(entityName: "Collection")
    }
    
    @NSManaged public var platform: String?
    @NSManaged public var items: NSSet?
    
    public var unwrappedName: String {
        platform ?? "Unknown name"
    }
    
    public var itemsArray: [Item] {
        let itemSet = items as? Set<Item> ?? []
        
        return itemSet.sorted {
            $0.unwrappedName < $1.unwrappedName
        }
    }
}

// MARK: Generated accessors for items
extension Collection {
    
    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)
    
    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)
    
    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)
    
    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)
    
}

extension Collection : Identifiable {
    
}
