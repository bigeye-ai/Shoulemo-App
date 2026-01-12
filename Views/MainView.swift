import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [UserSettings]
    @Query(sort: \WeightRecord.timestamp, order: .reverse) private var records: [WeightRecord]
    
    @State private var showingCheckIn = false
    @State private var inputWeight: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("瘦了么")
                    .font(.system(size: 60, weight: .black))
                    .foregroundColor(.green)
                
                if let currentSettings = settings.first {
                    Text("已堅持 \(currentSettings.checkInStreak) 天")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if let lastRecord = records.first, Calendar.current.isDateInToday(lastRecord.timestamp) {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.green)
                        Text("今日已簽到: \(lastRecord.weight, specifier: "%.1f") kg")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                } else {
                    Button(action: { showingCheckIn = true }) {
                        Text("立即簽到")
                            .font(.title.bold())
                            .foregroundColor(.black)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 40)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Text("設置監督人")
                        .foregroundColor(.gray)
                        .underline()
                }
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showingCheckIn) {
            CheckInSheet(inputWeight: $inputWeight, onSave: saveRecord)
        }
    }
    
    private func saveRecord() {
        guard let weight = Double(inputWeight) else { return }
        let newRecord = WeightRecord(weight: weight)
        modelContext.insert(newRecord)
        
        if let currentSettings = settings.first {
            currentSettings.lastCheckInDate = Date()
            currentSettings.checkInStreak += 1
        } else {
            let newSettings = UserSettings(checkInStreak: 1)
            newSettings.lastCheckInDate = Date()
            modelContext.insert(newSettings)
        }
        
        showingCheckIn = false
        inputWeight = ""
    }
}

struct CheckInSheet: View {
    @Binding var inputWeight: String
    var onSave: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("輸入今日體重 (kg)")
                .font(.headline)
            
            TextField("0.0", text: $inputWeight)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .font(.system(size: 40, weight: .bold))
            
            Button(action: onSave) {
                Text("確認簽到")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
        }
        .padding()
        .presentationDetents([.height(250)])
    }
}
