//
//  HomeworkView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 12.09.23.
//

import SwiftUI
import SwiftData

struct HomeworkView: View {
    @Query(
        FetchDescriptor(
            sortBy: [SortDescriptor(\Homework.title, order: .forward)]
        )
    ) var homeworkTasks: [Homework]
    
    @AppStorage("ppsubjects")
    var subjects: CodableWrapper<[Subject]> = .init(value: .init())
    
    @State var presentAdd: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(.all)
            
            if !subjects.value.isEmpty {
                HomeworkList(
                    homeworkTasks: homeworkTasks, presentAdd: $presentAdd
                )
                .scrollDisabled(homeworkTasks.isEmpty)
            }
        }
        .navigationTitle("Aufgaben")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Aufgabe hinzufügen", systemImage: "plus") {
                    presentAdd.toggle()
                }
                .disabled(subjects.value.isEmpty)
            }
        }
        .overlay {
            if subjects.value.isEmpty {
                EmptyView()
            } else if homeworkTasks.isEmpty {
                DoneView()
            }
        }
    }
    
    @ViewBuilder func DoneView() -> some View {
        if homeworkTasks.isEmpty {
            ContentUnavailableView(label: {
                Label(
                    "Du hast alles erledigt.",
                    systemImage: "checkmark.circle"
                )
                .foregroundStyle(Color.primary, Color.green)
            }, description: {
                Group {
                    Text("Tippe auf ") +
                        Text(Image(systemName: "plus"))
                        .foregroundStyle(Color.accentColor) +
                        Text(", um eine neue Aufgabe hinzuzufügen.")
                }
                .foregroundStyle(Color.primary)
            })
            .transition(.blurReplace)
        }
    }
    
    @ViewBuilder func EmptyView() -> some View {
        ContentUnavailableView(
            "Du hast noch keine Fächer erstellt.",
            systemImage: "tray.2.fill",
            description: Text("Gehe unter Einstellungen auf \"Fächer\".")
        )
        .foregroundStyle(
            Color.primary, Color.accentColor, Color.secondary
        )
        .transition(.identity)
    }
}

#Preview {
    HomeworkView()
}
