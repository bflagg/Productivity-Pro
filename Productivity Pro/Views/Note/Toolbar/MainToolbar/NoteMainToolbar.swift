//
//  NoteMainToolbar.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 29.09.22.
//

import SwiftUI
import StoreKit

struct NoteMainToolbar: ToolbarContent {
    @Environment(\.openWindow) var openWindow
    var contentObject: ContentObject
    
    @AppStorage("defaultFont") var defaultFont: String = "Avenir Next"
    @AppStorage("defaultFontSize") var defaultFontSize: Double = 12
    @AppStorage("createdNotes") var createdNotes: Int = 0
    
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var body: some ToolbarContent {
        
        ToolbarItem(id: "shapes", placement: .secondaryAction) {
            ShapesButton()
        }
        
        ToolbarItem(id: "textbox", placement: .secondaryAction) {
            TextFieldButton()
        }
        
        ToolbarItem(id: "media", placement: .secondaryAction) {
            MediaButton()
        }
    }
    
    func primaryColor() -> Color {
        let page = contentObject.note!.pages?.first(where: {
            $0.id == toolManager.activePage?.id
        })
        
        guard let color = page?.color else {
            return Color.gray
        }
        
        if color == "pageblack" || color == "pagegray" {
            return Color.white
        } else {
            return Color.black
        }
    }
}
