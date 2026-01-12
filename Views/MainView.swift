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
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(LocalizedStringKey("APP_TITLE"))
                        .font(.system(size: 70, weight: .black))
                        .foregroundColor(.green)
                    
                    Text(LocalizedStringKey("SLOGAN_WEIGHT_NEVER_LIES"))
                        .font(.headline)
                        .foregroundColor(.gray)
                        .tracking(5)
                }
                
                if let currentSettings = settings.first {
                    Text(String(format: String(localized: "DAYS_FACING_REALITY"), currentSettings.checkInStreak))
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                if let lastRecord = records.first, Calendar.current.isDateInToday(lastRecord.timestamp) {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 80, height: 70)
                            .foregroundColor(.green)
                        
                        Text(String(format: String(localized: "TODAY_RECORDED"), lastRecord.weight))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(LocalizedStringKey("NOT_THINNER_FILL_TOMORROW"))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    Button(action: { showingCheckIn = true }) {
                        VStack(spacing: 10) {
                            Text(LocalizedStringKey("CHECK_IN_NOW"))
                                .font(.system(size: 30, weight: .black))
                            Text(LocalizedStringKey("NOT_THINNER_MUST_FACE"))
                                .font(.caption)
                        }
                        .foregroundColor(.black)
                        .padding(.vertical, 25)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(0) // 硬朗風格
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                HStack(spacing: 40) {
                    NavigationLink(destination: TrendView()) {
                        VStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text(LocalizedStringKey("VIEW_TREND"))
                        }
                        .foregroundColor(.white)
                    }
                    
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "person.badge.shield.checkered")
                            Text(LocalizedStringKey("SUPERVISOR"))
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
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
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 30) {
                Text(LocalizedStringKey("TODAY_THINNER"))
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.green)
                
                TextField(LocalizedStringKey("ENTER_WEIGHT"), text: $inputWeight)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                
                Button(action: onSave) {
                    Text(LocalizedStringKey("FACE_REALITY"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
        .presentationDetents([.height(350)])
    }
}
