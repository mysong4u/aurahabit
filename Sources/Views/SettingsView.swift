import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Privacy")) {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text("100% Offline & Secure")
                                .font(.headline)
                            Text("All your data is stored locally on your device. We do not use servers.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Preferences")) {
                    NavigationLink(destination: TimerSettingsView()) {
                        Label("Timer Settings", systemImage: "timer")
                    }
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Label("Appearance", systemImage: "paintpalette")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
