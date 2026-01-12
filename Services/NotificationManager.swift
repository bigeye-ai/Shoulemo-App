import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("通知權限已獲取")
            } else if let error = error {
                print("通知權限獲取失敗: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("DAILY_REMINDER_TITLE", comment: "")
        content.body = NSLocalizedString("DAILY_REMINDER_BODY", comment: "")
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 晚上 8 點提醒
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendUrgentAlert() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("WARNING_NOT_CHECKED_IN", comment: "")
        content.body = NSLocalizedString("WARNING_NOT_CHECKED_IN", comment: "") // Body can be same as title for urgency
        content.sound = .defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "urgent_alert", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
