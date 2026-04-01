import SwiftUI
import OSLog
import UserNotifications

@main
struct MireaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onChange(of: scenePhase) { _, newPhase in
                    Logger.lifecycle.info("Статус приложения: \(String(describing: newPhase))")
                }
        }
    }
}

#Preview {
    MainView()
}
