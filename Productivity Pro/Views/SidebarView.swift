//
//  SidebarView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 13.11.24.
//

import SwiftUI

struct SidebarView: View {
    @Environment(NavigationManager.self) var navigationManager
    
    @State var notifications = NotificationManager()
    var contentObjects: [ContentObject]
    
    var body: some View {
        Group {
            @Bindable var navigation = navigationManager
            
            List(selection: $navigation.selection) {
                NavigationLink(value: ViewPresentation.gemini) {
                    Label("Gemini", systemImage: "sparkles")
                }
                
                Section("Notizen") {
                    NavigationLink(value: ViewPresentation.finder) {
                        Label("Finder", systemImage: "doc.fill")
                    }
                    
                    NavigationLink(value: ViewPresentation.search) {
                        Label("Suchen", systemImage: "magnifyingglass")
                    }
                    
                    NavigationLink(value: ViewPresentation.trash) {
                        Label {
                            Text("Papierkorb")
                                .foregroundStyle(.red)
                        } icon: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Section("Organisation") {
                    NavigationLink(value:  ViewPresentation.tasks) {
                        Label("Aufgaben", systemImage: "checklist")
                    }
                    
                    NavigationLink(value: ViewPresentation.schedule) {
                        Label("Stundenplan", systemImage: "calendar")
                    }
                    
//                    NavigationLink(value: ViewPresentation.exams) {
//                        Label("Prüfungen", systemImage: "graduationcap.fill")
//                    }
                }
                
                Section("Einstellungen") {
                    NavigationLink(value: ViewPresentation.subjects) {
                        Label("Fächer", systemImage: "tray.2.fill")
                    }
                    
                    NavigationLink(value: ViewPresentation.general) {
                        Label("Allgemein", systemImage: "gearshape.fill")
                    }
                }
            }
            .navigationTitle("Productivity Pro")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Footer()
                }
            }
        }
    }
    
    @ViewBuilder func Footer() -> some View {
        Group {
            Text("Entwickelt mit ") +
            Text("\(Image(systemName: "heart.fill"))")
                .foregroundStyle(Color.red) +
            Text(" für Schüler")
        }
        .font(.caption)
        .foregroundStyle(Color.secondary)
    }
}
