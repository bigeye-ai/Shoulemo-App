import SwiftUI
import SwiftData

@main
struct ShoulemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WeightRecord.self,
            UserSettings.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.scheduleDailyReminder()
    }
}
