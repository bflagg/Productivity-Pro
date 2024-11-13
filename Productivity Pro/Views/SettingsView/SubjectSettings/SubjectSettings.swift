//
//  SubjectSettings.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.09.23.
//

import SwiftData
import SwiftUI

struct SubjectSettings: View {
    @Environment(\.modelContext) var context
    
    @Query(
        FetchDescriptor(
            sortBy: [SortDescriptor(\Homework.title, order: .forward)]
        )
    ) var homeworkTasks: [Homework]
    
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
    
    @State var addSubject: Bool = false
    @State var purchaseView: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(.all)
            
            List {
                if subjects.value.isEmpty == false {
                    Section("Meine Fächer") {
                        ForEach(
                            subjects.value.sorted(by: { $0.title < $1.title })
                        ) { subject in
                            SubjectSettingsRow(
                                subject: subject,
                                homeworkTasks: homeworkTasks
                            )
                        }
                    }
                }
            }
            .animation(.bouncy, value: subjects.value.count)
            .scrollDisabled(subjects.value.isEmpty)
            .scrollContentBackground(.hidden)
            .navigationTitle("Fächer")
            .sheet(isPresented: $addSubject) {
                AddSubject(addSubject: $addSubject)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fach hinzufügen", systemImage: "plus") {
                        addSubject.toggle()
                    }
                }
            }
        }
        .overlay {
            if subjects.value.isEmpty { EmptyView() }
        }
    }
    
    @ViewBuilder func EmptyView() -> some View {
        ContentUnavailableView(label: {
            Label(
                "Du hast noch keine Fächer erstellt.",
                systemImage: "tray.2.fill"
            )
            .foregroundStyle(Color.primary, Color.accentColor)
        }, description: {
            Group {
                Text("Tippe auf ") +
                Text(Image(systemName: "plus"))
                    .foregroundStyle(Color.accentColor) +
                Text(", um eine neues Fach hinzuzufügen.")
            }
            .foregroundStyle(Color.primary)
        })
        .transition(.asymmetric(
            insertion: .opacity, removal: .identity
        ))
    }
}

#Preview {
    SubjectSettings()
}
