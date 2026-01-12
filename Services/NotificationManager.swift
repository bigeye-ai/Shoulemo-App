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
        content.title = "瘦了么？"
        content.body = "今天還沒簽到！再不簽到我就要發郵件給你的監督人了！"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 晚上 8 點提醒
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendUrgentAlert() {
        let content = UNMutableNotificationContent()
        content.title = "警告：減肥失敗預警"
        content.body = "你已經 24 小時沒簽到了，監督人正在提刀趕來的路上..."
        content.sound = .defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "urgent_alert", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
