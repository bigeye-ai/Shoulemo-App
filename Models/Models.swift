import Foundation
import SwiftData

@Model
final class WeightRecord {
    var timestamp: Date
    var weight: Double
    var note: String
    
    init(timestamp: Date = Date(), weight: Double, note: String = "") {
        self.timestamp = timestamp
        self.weight = weight
        self.note = note
    }
}

@Model
final class UserSettings {
    var targetWeight: Double
    var supervisorEmail: String
    var userName: String
    var lastCheckInDate: Date?
    var checkInStreak: Int
    
    init(targetWeight: Double = 70.0, supervisorEmail: String = "", userName: String = "瘦友", checkInStreak: Int = 0) {
        self.targetWeight = targetWeight
        self.supervisorEmail = supervisorEmail
        self.userName = userName
        self.checkInStreak = checkInStreak
    }
}
