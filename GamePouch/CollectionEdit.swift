import SwiftUI

struct CollectionEdit: View {
    
    @StateObject var collection: Collection
    @State private var collectionPlatform: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Edit Collection", text: $collectionPlatform)
                    .textFieldStyle(.roundedBorder)
                Button(action: updateCollection) {
                    Label("", systemImage: "arrowshape.turn.up.left")
                }
            }.padding()
            Text(collection.platform ?? "")
            Spacer()
        }
    }
    
    private func updateCollection() {
        withAnimation {
            collection.platform = collectionPlatform
            PersistenceController.shared.saveContext()
        }
    }
}

struct CollectionEdit_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newCollection = Collection(context: viewContext)
        
        newCollection.platform = "Playstation 2"
        
        return CollectionEdit(collection: newCollection)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
