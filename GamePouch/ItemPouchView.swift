import SwiftUI

struct ItemPouchView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @StateObject var collection: Collection
    @State private var itemName: String = ""
    
    var body: some View {
        
        VStack {
            Text("")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action : {
                    self.mode.wrappedValue.dismiss()
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.blue)
                })
    
            Spacer()
            HStack {
                Button(action: addItem) {
                    Label("", systemImage: "magnifyingglass")
                }.disabled(itemName.isEmpty)
                TextField("Title", text: $itemName).textFieldStyle(.roundedBorder)
                Button(action: addItem) {
                    Label("", systemImage: "plus")
                }.disabled(itemName.isEmpty)
            }.padding()
            List {
                ForEach(collection.itemsArray) { item in
                    NavigationLink(destination: ItemDetailsView()) {
                        Text(item.unwrappedName)
                    }
                }.onDelete(perform: deleteItem)
            }
        }.navigationTitle(collection.platform ?? "Null")
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.title = itemName
            
            collection.addToItems(newItem)
            PersistenceController.shared.saveContext()
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = collection.itemsArray[index]
                viewContext.delete(item)
                PersistenceController.shared.saveContext()
            }
        }
    }
}

struct ItemPouchView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        
        let newItem = Collection(context: viewContext)
        newItem.platform = "Playstation 3"
        
        let item1 = Item(context: viewContext)
        item1.title = "Call of Duty: Modern Warfare"
        
        let item2 = Item(context: viewContext)
        item2.title = "Assassins Creed"
        
        newItem.addToItems(item1)
        newItem.addToItems(item2)
        
        return ItemPouchView(collection: newItem)                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
