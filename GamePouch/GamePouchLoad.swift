import SwiftUI

@main
struct GamePouchLoad: App {
    
    @StateObject var appLockVM = AppLockViewModel()
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    @State var blurRadius: CGFloat = 0
    
    
    var body: some Scene {
        WindowGroup {
            CollectionView()
                .environmentObject(appLockVM)
                .blur(radius: blurRadius)
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }.onChange(of: scenePhase) { value in
            persistenceController.saveContext()
            switch value {
            case .active:
                blurRadius = 0
            case.background:
                appLockVM.isAppUnlocked = false
            case.inactive:
                blurRadius = 5
            @unknown default:
                print("unknown")
            }
        }
    }
}
