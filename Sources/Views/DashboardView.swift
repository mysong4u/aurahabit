import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with Ring Chart
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentDate, format: .dateTime.month().day().weekday())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Today's Progress")
                                .font(.title2.bold())
                        }
                        Spacer()
                        
                        ProgressRingView(progress: calculateProgress())
                            .frame(width: 60, height: 60)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Habits List
                    VStack(spacing: 12) {
                        ForEach(habits) { habit in
                            HabitRowView(habit: habit, date: currentDate)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Dashboard")
        }
    }
    
    private func calculateProgress() -> Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompleted(on: currentDate) }.count
        return Double(completed) / Double(habits.count)
    }
}

struct ProgressRingView: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .opacity(0.3)
                .foregroundColor(.indigo)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(.indigo)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            Text(String(format: "%.0f%%", min(progress, 1.0) * 100.0))
                .font(.caption.bold())
        }
    }
}

struct HabitRowView: View {
    @Bindable var habit: Habit
    var date: Date
    
    var body: some View {
        HStack {
            Image(systemName: habit.iconName)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(habit.color)
                .cornerRadius(10)
            
            Text(habit.title)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    habit.toggleCompletion(for: date)
                    // Haptic Feedback
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                }
            }) {
                Image(systemName: habit.isCompleted(on: date) ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(habit.isCompleted(on: date) ? habit.color : .gray)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
