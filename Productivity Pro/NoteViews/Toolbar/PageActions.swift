//
//  NoteSidePageActions.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 18.09.23.
//

import SwiftUI

extension NoteToolbar {
    @ViewBuilder func PageActions() -> some View {
        
        Menu(content: {
            Section {
                Button(action: {
                    toolManager.pencilKit = false
                    subviewManager.addPage = true
                }) {
                    Label("Seite hinzufügen", systemImage: "doc.badge.plus")
                }

                Button(action: {
                    toolManager.pencilKit = false
                    subviewManager.importFile = true
                }) {
                    Label("Datei importieren", systemImage: "square.and.arrow.down")
                }
            
                Button(action: {
                    toolManager.pencilKit = false
                    subviewManager.scanDocument = true
                }) {
                    Label("Dokument scannen", systemImage: "doc.text.fill.viewfinder")
                }
            }
            
            Section {
                Button(action: {
                    toolManager.pencilKit = false
                    subviewManager.changePage = true
                }) {
                    Label("Vorlage ändern", systemImage: "grid")
                }
                .disabled(toolManager.activePage?.type != PPPageType.template.rawValue)
                
                Button(role: .destructive, action: {
                    toolManager.pencilKit = false
                    subviewManager.deletePage = true
                }) {
                    Label("Seite löschen", systemImage: "trash")
                }
                .disabled(contentObject.note?.pages?.count == 1)
            }
        }) {
            Label("Seite", systemImage: "doc.badge.ellipsis")
        }
    }
}
