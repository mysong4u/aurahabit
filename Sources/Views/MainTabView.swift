import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @AppStorage("appAccentColor") private var appAccentColor = "#6366F1"
    @AppStorage("appTheme") private var appTheme = "system"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "checklist")
                }
                .tag(0)
            
            HabitManagerView()
                .tabItem {
                    Label("Habits", systemImage: "list.star")
                }
                .tag(1)
            
            TimerView()
                .tabItem {
                    Label("Focus", systemImage: "timer")
                }
                .tag(2)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(4)
        }
        .tint(Color(hex: appAccentColor) ?? .indigo)
        .preferredColorScheme(selectedScheme)
    }
    
    private var selectedScheme: ColorScheme? {
        switch appTheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
