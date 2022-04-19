import Foundation
import CoreData

extension Item {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var collections: Collection
    
    public var unwrappedName: String {
        title ?? "Unknown name"
    }
}

extension Item : Identifiable {
    
}
