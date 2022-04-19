import SwiftUI
import Combine

struct CollectionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var collectionInput: String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Collection.platform, ascending: true)],
        animation: .default)
    private var collections: FetchedResults<Collection>
    @EnvironmentObject var appLockVM:AppLockViewModel
    
    var body: some View {
        ZStack{
            if !appLockVM.isAppLockEnabled || appLockVM.isAppUnlocked {
                NavigationView {
                    VStack {
                        HStack {
                            Button(action: addCollection) {
                                Label("", systemImage: "magnifyingglass")
                            }.disabled(collectionInput.isEmpty)
                            TextField("Playstation, Xbox, PC...", text: $collectionInput).textFieldStyle(.roundedBorder)
                            Button(action: addCollection) {
                                Label("", systemImage: "plus")
                            }.disabled(collectionInput.isEmpty)
                        }.padding()
                        List {
                            ForEach(collections) { collection in
                                NavigationLink(destination: ItemPouchView(collection: collection)) {
                                    Text(collection.platform ?? "")
                                }
                            }.onDelete(perform: deleteCollection)
                        }
                        GroupBox {
                            HStack{
                                Toggle(isOn: $appLockVM.isAppLockEnabled, label: {
                                    Image(systemName: "lock")
                                        .font(.title2)
                                        .foregroundColor(.red)
                                }).onChange(of: appLockVM.isAppLockEnabled, perform: {value in
                                    appLockVM.appLockStateChange(appLockState: value)
                                })
                            }
                        }
                    }.navigationTitle("Game Pouch")
                }
            }
            else {
                AppLockView().environmentObject(appLockVM)
            }
        }.onAppear {
            if appLockVM.isAppLockEnabled{
                appLockVM.appLockValidation()
            }
        }
    }
    
    
    private func addCollection() {
        withAnimation {
            let newCollection = Collection(context: viewContext)
            newCollection.platform = collectionInput
            PersistenceController.shared.saveContext()
        }
    }
    
    private func deleteCollection(offsets: IndexSet) {
        withAnimation {
            offsets.map { collections[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

