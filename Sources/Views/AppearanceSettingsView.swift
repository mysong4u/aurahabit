import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("appAccentColor") private var appAccentColor = "#6366F1" // Indigo default
    @AppStorage("appTheme") private var appTheme = "system"
    
    let colors = [
        ("#6366F1", "Indigo"),
        ("#FF2D55", "Rose"),
        ("#007AFF", "Blue"),
        ("#34C759", "Green"),
        ("#FF9500", "Orange"),
        ("#AF52DE", "Purple")
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Theme Mode")) {
                Picker("Theme", selection: $appTheme) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)
            }
            
            Section(header: Text("Accent Color")) {
                ForEach(colors, id: \.0) { hex, name in
                    HStack {
                        Circle()
                            .fill(Color(hex: hex) ?? .indigo)
                            .frame(width: 25, height: 25)
                        Text(name)
                        Spacer()
                        if appAccentColor == hex {
                            Image(systemName: "checkmark")
                                .foregroundColor(.indigo)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appAccentColor = hex
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }
            }
        }
        .navigationTitle("Appearance")
    }
}
