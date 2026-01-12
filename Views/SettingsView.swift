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
            Section(header: Text("個人信息")) {
                TextField("你的名字", text: $userName)
                TextField("目標體重 (kg)", text: $targetWeight)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("監督機制"), footer: Text("如果你連續 24 小時未簽到，系統將自動向該郵箱發送告狀信。")) {
                TextField("監督人郵箱", text: $supervisorEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            Button("保存設置") {
                saveSettings()
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.green)
        }
        .navigationTitle("設置")
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
