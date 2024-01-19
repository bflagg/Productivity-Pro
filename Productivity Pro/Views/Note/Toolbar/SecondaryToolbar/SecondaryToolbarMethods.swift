//
//  NoteSideActionMethods.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 19.06.23.
//

import Foundation

extension NoteSecondaryToolbar {
    func toggleOverview() {
        toolManager.pencilKit = false
        subviewManager.overviewSheet.toggle()
    }
    
    func toggleInspector() {
        let item = toolManager.activeItem
        toolManager.activeItem = nil
        toolManager.activeItem = item
        
        subviewManager.showInspector.toggle()
    }
}
