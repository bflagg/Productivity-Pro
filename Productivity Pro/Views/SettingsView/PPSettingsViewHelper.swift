//
//  DeskViewHelper.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.09.23.
//

import SwiftUI

extension PPSettingsView {
    @ViewBuilder func Settings() -> some View {
        Section("Design") {
            NavigationLink(destination: {
                AppIconSettings()
            }) {
                Label("App Icon", systemImage: "app.gift")
            }
            .frame(height: 30)
        }
    }
    
    @ViewBuilder func DataAndNotifications() -> some View {
        Section("Daten und Benachrichtigungen") {
            NavigationLink(destination: {
                BackupSettings()
            }) {
                Label(
                    "Backup", systemImage: "externaldrive.badge.timemachine"
                )
            }
            .frame(height: 30)
            
            DatePicker(
                selection: $notificationTime,
                displayedComponents: .hourAndMinute
            ) {
                Label(
                    "Uhrzeit der Benachrichtigung bei Aufgaben",
                    systemImage: "app.badge"
                )
            }
            .frame(height: 30)
        }
    }
}
