//
//  AddHomework.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 21.09.23.
//

import SwiftData
import SwiftUI

struct HomeworkAddView: View {
    @Environment(\.modelContext) var context
    var contentObjects: [ContentObject]
    
    @AppStorage("ppsubjects")
    var subjects: CodableWrapper<[Subject]> = .init(value: .init())
    
    @AppStorage("notificationTime")
    var notificationTime: Date = Calendar.current.date(
        bySettingHour: 15, minute: 30, second: 00, of: Date()
    )!
    
    @State var notePicker: Bool = false
    @State var pickedNote: String = ""
    @State var homework: Homework = .init()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Titel", text: $homework.title)
                        .frame(height: 30)
                    
                    Picker("Fach", selection: $homework.subject) {
                        Section {
                            ForEach(subjects.value.sorted(by: { $0.title < $1.title })) { subject in
                                Text(subject.title)
                                    .tag(subject.title)
                            }
                        }
                    }
                    .frame(height: 30)
                }
                
                Section {
                    DatePicker(
                        "Zu erledigen bis zum",
                        selection: $homework.date,
                        in: dateRange,
                        displayedComponents: .date
                    )
                    .frame(height: 30)
                    
                    HStack {
                        Text(
                            LocalizedStringKey(pickedNote.isEmpty ? "Notiz" : contentObjects.first(where: {
                                $0.id.uuidString == pickedNote
                            })?.title ?? "Fehler")
                        )
                        
                        Spacer()
                        
                        Button(pickedNote.isEmpty ? "Auswählen" : "Entfernen") {
                            if pickedNote.isEmpty {
                                notePicker.toggle()
                            } else {
                                pickedNote = ""
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(Color.primary)
                    }
                    .frame(height: 30)
                    .sheet(isPresented: $notePicker) {
                        ObjectPicker(
                            objects: contentObjects,
                            isPresented: $notePicker, id: UUID(),
                            selectedObject: $pickedNote,
                            type: .file
                        )
                    }
                }
                
                TextEditor(text: $homework.homeworkDescription)
                    .listRowInsets(edgeInsets())
                    .frame(minHeight: 150)
            }
            .environment(\.defaultMinListRowHeight, 10)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Hinzufügen") { add() }
                        .disabled(homework.title == "")
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { isPresented.toggle() }
                }
            }
        }
        .scrollIndicators(.never)
        .onAppear {
            homework.date = Calendar.current.date(
                byAdding: .day, value: 1, to: homework.date
            )!
            
            homework.subject = subjects.value.sorted(by: { $0.title < $1.title })[0].title
        }
    }
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(
            byAdding: .day, value: 1, to: midnight
        )!
        
        let max = calendar.date(
            byAdding: .year, value: 1, to: tomorrow
        )!
        
        return tomorrow ... max
    }()
}
