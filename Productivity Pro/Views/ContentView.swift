//
//  ContentView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.09.23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State var toolManager: ToolManager = ToolManager()
    @State var selectedTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            DeskView()
                .toolbarBackground(.visible, for: .tabBar)
                .tag(0)
                .tabItem {
                    Label("Schreibtisch", systemImage: "lamp.desk")
                }
            
            FileSystemView()
                .toolbarBackground(.visible, for: .tabBar)
                .tag(1)
                .tabItem {
                    Label("Notizen", systemImage: "doc")
                }
            
            ScheduleViewContainer()
                .modifier(PremiumBadge())
                .toolbarBackground(.visible, for: .tabBar)
                .tag(2)
                .tabItem {
                    Label("Stundenplan", systemImage: "calendar")
                }
            
            HomeworkView()
                .modifier(PremiumBadge())
                .toolbarBackground(.visible, for: .tabBar)
                .tag(3)
                .tabItem {
                    Label("Aufgaben", systemImage: "checklist")
                }
            
            /*            
            LibraryView()
                .toolbarBackground(.visible, for: .tabBar)
                .tag(4)
                .tabItem {
                    Label("Bibliothek", systemImage: "books.vertical")
                }
             */
            
        }
        .environment(toolManager)
        .scrollIndicators(.hidden)
        .onAppear {
            askNotificationPermission()
        }
    }
    
    func askNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { success, error in }
    }
}
