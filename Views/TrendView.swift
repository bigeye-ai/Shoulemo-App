import SwiftUI
import SwiftData
import Charts

struct TrendView: View {
    @Query(sort: \WeightRecord.timestamp, order: .forward) private var records: [WeightRecord]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(LocalizedStringKey("VIEW_TREND"))
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.white)
                    
                    Text(LocalizedStringKey("SLOGAN_FAT_TREMBLES"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                if records.isEmpty {
                    Spacer()
                    Text(LocalizedStringKey("NO_DATA_YET"))
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    VStack {
                        Chart {
                            ForEach(records) { record in
                                AreaMark(
                                    x: .value("日期", record.timestamp),
                                    y: .value("體重", record.weight)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green.opacity(0.5), .green.opacity(0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .interpolationMethod(.catmullRom)
                                
                                LineMark(
                                    x: .value("日期", record.timestamp),
                                    y: .value("體重", record.weight)
                                )
                                .foregroundStyle(.green)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .interpolationMethod(.catmullRom)
                                
                                PointMark(
                                    x: .value("日期", record.timestamp),
                                    y: .value("體重", record.weight)
                                )
                                .foregroundStyle(.green)
                                .annotation(position: .top) {
                                    if record.id == records.last?.id {
                                        VStack {
                                            Text("\(record.weight, specifier: "%.1f")")
                                                .font(.caption.bold())
                                                .foregroundColor(.black)
                                                .padding(5)
                                                .background(Color.green)
                                                .cornerRadius(5)
                                        }
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(.white.opacity(0.1))
                                AxisValueLabel(format: .dateTime.month().day(), centered: true)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(.white.opacity(0.1))
                                AxisValueLabel()
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(height: 300)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                    }
                    .padding()
                }
                
                Spacer()
                
                Text(LocalizedStringKey("NOT_THINNER_MUST_FACE"))
                    .font(.caption)
                    .italic()
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.green)
    }
}
