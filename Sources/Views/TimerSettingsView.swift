import SwiftUI

struct TimerSettingsView: View {
    @AppStorage("focusDuration") private var focusDuration = 25 // in minutes
    @AppStorage("shortBreak") private var shortBreak = 5 // in minutes
    @AppStorage("longBreak") private var longBreak = 15 // in minutes
    
    var body: some View {
        Form {
            Section(header: Text("Timer Intervals (Minutes)")) {
                Stepper(value: $focusDuration, in: 5...120, step: 5) {
                    HStack {
                        Image(systemName: "brain.headprofile.lifemax")
                            .foregroundColor(.indigo)
                        Text("Focus Duration")
                        Spacer()
                        Text("\(focusDuration) min")
                            .foregroundColor(.secondary)
                    }
                }
                
                Stepper(value: $shortBreak, in: 1...30, step: 1) {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundColor(.orange)
                        Text("Short Break")
                        Spacer()
                        Text("\(shortBreak) min")
                            .foregroundColor(.secondary)
                    }
                }
                
                Stepper(value: $longBreak, in: 5...60, step: 5) {
                    HStack {
                        Image(systemName: "bed.double.fill")
                            .foregroundColor(.blue)
                        Text("Long Break")
                        Spacer()
                        Text("\(longBreak) min")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Timer Settings")
    }
}
