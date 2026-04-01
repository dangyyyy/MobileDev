import SwiftUI
import UserNotifications

// MARK: - Push
func sendLocalPush() {
    let content = UNMutableNotificationContent()
    content.title = "МИРЭА"
    content.body = "Жесткое уведомление"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}
