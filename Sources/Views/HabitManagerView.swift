import SwiftUI
import SwiftData

struct HabitManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    HStack {
                        Image(systemName: habit.iconName)
                            .foregroundColor(habit.color)
                        Text(habit.title)
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
    
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var selectedColor = "#FF2D55" // Default Red
    @State private var selectedIcon = "star.fill"
    
    let colors = ["#FF2D55", "#007AFF", "#34C759", "#FF9500", "#AF52DE", "#FFCC00"]
    let icons = ["star.fill", "book.fill", "figure.walk", "drop.fill", "flame.fill", "bolt.fill"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Habit Name", text: $title)
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 15) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .foregroundColor(selectedIcon == icon ? Color(hex: selectedColor) : .gray)
                                .padding(10)
                                .background(selectedIcon == icon ? Color(hex: selectedColor)?.opacity(0.2) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Color")) {
                    HStack(spacing: 15) {
                        ForEach(colors, id: \.self) { colorHex in
                            Circle()
                                .fill(Color(hex: colorHex) ?? .gray)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == colorHex ? 3 : 0)
                                )
                                .onTapGesture {
                                    selectedColor = colorHex
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newHabit = Habit(title: title, iconName: selectedIcon, colorHex: selectedColor)
                        modelContext.insert(newHabit)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
