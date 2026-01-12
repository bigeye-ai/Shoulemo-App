import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]
    
    @State private var userName: String = ""
    @State private var targetWeight: String = ""
    @State private var supervisorEmail: String = ""
    
    var body: some View {
        Form {
            Section(header: Text(LocalizedStringKey("PERSONAL_INFO"))) {
                TextField(LocalizedStringKey("YOUR_NAME"), text: $userName)
                TextField(LocalizedStringKey("TARGET_WEIGHT"), text: $targetWeight)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text(LocalizedStringKey("SUPERVISION_MECHANISM")), footer: Text(LocalizedStringKey("SUPERVISOR_EMAIL_FOOTER"))) {
                TextField(LocalizedStringKey("SUPERVISOR_EMAIL"), text: $supervisorEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            Button(LocalizedStringKey("SAVE_SETTINGS")) {
                saveSettings()
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.green)
        }
        .navigationTitle(LocalizedStringKey("SETTINGS"))
        .onAppear {
            if let current = settings.first {
                userName = current.userName
                targetWeight = String(current.targetWeight)
                supervisorEmail = current.supervisorEmail
            }
        }
    }
    
    private func saveSettings() {
        let target = Double(targetWeight) ?? 70.0
        if let current = settings.first {
            current.userName = userName
            current.targetWeight = target
            current.supervisorEmail = supervisorEmail
        } else {
            let newSettings = UserSettings(targetWeight: target, supervisorEmail: supervisorEmail, userName: userName)
            modelContext.insert(newSettings)
        }
    }
}
