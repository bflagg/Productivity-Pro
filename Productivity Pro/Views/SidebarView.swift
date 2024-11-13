//
//  SidebarView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 13.11.24.
//

import SwiftUI

struct SidebarView: View {
    @State var notifications = NotificationManager()
    var contentObjects: [ContentObject]
    
    var body: some View {
        List {
            NavigationLink {
                Text("Gemini")
            } label: {
                Label("Gemini", systemImage: "sparkles")
            }
            
            Section("Notizen") {
                NavigationLink {
                    FileSystemView(contentObjects: contentObjects)
                } label: {
                    Label("Finder", systemImage: "doc.fill")
                }
                
                NavigationLink {
                    Text("Suchen")
                } label: {
                    Label("Suchen", systemImage: "magnifyingglass")
                }
            }
            
            Section("Organisation") {
                NavigationLink {
                    HomeworkView()
                        .onAppear {
                            notifications.askPermission()
                        }
                } label: {
                    Label("Aufgaben", systemImage: "checklist")
                }
                
                NavigationLink {
                    ScheduleViewContainer()
                } label: {
                    Label("Stundenplan", systemImage: "calendar")
                }
            }
            
            Section("Einstellungen") {
                NavigationLink {
                    
                } label: {
                    Label("Fächer", systemImage: "tray.2.fill")
                }
                
                NavigationLink {
                    PPSettingsView()
                } label: {
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
