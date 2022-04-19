import SwiftUI
import Combine

struct AppSecurityView:View {
    
    @EnvironmentObject var appLockVM:AppLockViewModel
    
    var body: some View{
        NavigationView{
            Toggle(isOn: $appLockVM.isAppLockEnabled, label: {
                Image(systemName: "lock")
            }).onChange(of: appLockVM.isAppLockEnabled, perform: { value in
                appLockVM.appLockStateChange(appLockState: value)
                
            })
        }
    }
}
