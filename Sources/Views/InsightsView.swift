import SwiftUI
import SwiftData
import Charts

struct InsightsView: View {
    @Query private var sessions: [FocusSession]
    @Query private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Total Focus Time Card
                    let totalSeconds = sessions.reduce(0) { $0 + $1.durationInSeconds }
                    let totalHours = Double(totalSeconds) / 3600.0
                    
                    VStack(alignment: .leading) {
                        Text("Total Focus Time")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f Hours", totalHours))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.indigo)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Chart
                    Text("Focus Time by Habit")
                        .font(.title2.bold())
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Chart {
                        ForEach(habits) { habit in
                            let habitSeconds = habit.sessions.reduce(0) { $0 + $1.durationInSeconds }
                            let minutes = Double(habitSeconds) / 60.0
                            
                            BarMark(
                                x: .value("Habit", habit.title),
                                y: .value("Minutes", minutes)
                            )
                            .foregroundStyle(habit.color)
                            .cornerRadius(8)
                        }
                    }
                    .frame(height: 250)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
        }
    }
}
