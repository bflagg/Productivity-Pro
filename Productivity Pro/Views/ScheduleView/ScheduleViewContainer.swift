//
//  ScheduleViewContainer.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 11.09.23.
//

import SwiftUI

struct ScheduleViewContainer: View {
    @Environment(\.horizontalSizeClass) var hsc
    @State var isEditing: Bool = false
    
    @AppStorage("ppsubjects")
    var subjects: CodableWrapper<[Subject]> = .init(value: .init())
    
    @AppStorage("ppschedule")
    var schedule: CodableWrapper<[ScheduleDay]> = .init(value: [
        ScheduleDay(id: String(localized: "Montag")),
        ScheduleDay(id: String(localized: "Dienstag")),
        ScheduleDay(id: String(localized: "Mittwoch")),
        ScheduleDay(id: String(localized: "Donnerstag")),
        ScheduleDay(id: String(localized: "Freitag"))
    ])
    
    var body: some View {
        ScheduleView(
            isEditing: $isEditing, hsc: hsc,
            schedule: $schedule
        )
        .navigationTitle("Stundenplan")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: !isEditing ? "pencil" : "pencil.slash") {
                    withAnimation(.smooth(duration: 0.2)) {
                        isEditing.toggle()
                    }
                }
                .disabled(subjects.value.isEmpty)
            }
        }
        .overlay {
            if empty() { EmptyView() }
        }
    }
    
    @ViewBuilder func EmptyView() -> some View {
        ContentUnavailableView(label: {
            Label(
                "Du hast noch keinen Stundenplan erstellt.",
                systemImage: "calendar"
            )
            .foregroundStyle(Color.primary, Color.accentColor)
        }, description: {
            Group {
                Text("Tippe auf ") +
                Text(Image(systemName: "pencil"))
                    .foregroundStyle(Color.accentColor) +
                Text(", um deinen Stundenplan zu bearbeiten.")
            }
            .foregroundStyle(Color.primary)
        })
        .transition(.opacity)
    }
    
    func empty() -> Bool {
        if subjects.value.isEmpty || isEditing {
            return false
        }
        
        for row in schedule.value {
            if row.subjects.isEmpty == false {
                return false
            }
        }
        
        return true
    }
}
