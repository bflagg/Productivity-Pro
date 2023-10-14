//
//  TopToolbar.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 29.09.22.
//

import SwiftUI

struct NoteSideActions: ToolbarContent {
    @Environment(\.undoManager) var undoManager
    @Environment(\.horizontalSizeClass) var hsc
    
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var contentObject: ContentObject
    var body: some ToolbarContent {
        
        ToolbarItemGroup(placement: .topBarLeading) {
            PageActions()
            
            Button(action: {
                toolManager.activePage?.isBookmarked.toggle()
            }) {
                Image(
                    systemName: toolManager.activePage?.isBookmarked  == true ? "bookmark.fill" : "bookmark"
                )
                .tint(Color.red)
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            @Bindable var subviewValue = subviewManager
            Button("Inspektor", systemImage: "sidebar.trailing") {
                toggleInspector()
            }
        }
        
    }
}

