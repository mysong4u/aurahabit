import SwiftUI
import SwiftData
import AVFoundation

struct TimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    
    @AppStorage("focusDuration") private var focusDuration = 25
    @State private var selectedHabit: Habit?
    @State private var timeRemaining = 25 * 60
    @State private var isRunning = false
    @State private var timer: Timer?
    
    private var totalTime: Int {
        focusDuration * 60
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                // Habit Picker
                Menu {
                    ForEach(habits) { habit in
                        Button(action: {
                            selectedHabit = habit
                        }) {
                            Label(habit.title, systemImage: habit.iconName)
                        }
                    }
                } label: {
                    HStack {
                        if let habit = selectedHabit {
                            Image(systemName: habit.iconName)
                            Text(habit.title)
                        } else {
                            Text("Select Habit to Focus On")
                        }
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                
                // Timer Circle
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .opacity(0.2)
                        .foregroundColor(selectedHabit?.color ?? .indigo)
                    
                    let progress = 1.0 - (Double(timeRemaining) / Double(totalTime))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(progress))
                        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                        .foregroundColor(selectedHabit?.color ?? .indigo)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: progress)
                    
                    VStack {
                        Text(timeString(time: timeRemaining))
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                        Text(isRunning ? "Focusing..." : "Ready")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(40)
                
                // Controls
                HStack(spacing: 30) {
                    Button(action: {
                        isRunning ? stopTimer() : startTimer()
                    }) {
                        Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(selectedHabit?.color ?? .indigo)
                    }
                    
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Pomodoro")
            .onAppear {
                if selectedHabit == nil {
                    selectedHabit = habits.first
                }
                if !isRunning {
                    timeRemaining = totalTime
                }
            }
            .onChange(of: focusDuration) { oldValue, newValue in
                if !isRunning {
                    timeRemaining = newValue * 60
                }
            }
        }
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                finishSession()
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    private func resetTimer() {
        stopTimer()
        timeRemaining = totalTime
    }
    
    private func finishSession() {
        stopTimer()
        AudioServicesPlaySystemSound(1005) // Alert sound
        
        // Save session
        if let habit = selectedHabit {
            let session = FocusSession(durationInSeconds: totalTime, habit: habit)
            habit.sessions.append(session)
            // ModelContext saves automatically, but can force if needed
        }
        resetTimer()
    }
    
    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
