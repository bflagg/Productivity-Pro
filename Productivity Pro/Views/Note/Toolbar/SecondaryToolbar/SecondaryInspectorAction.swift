//
//  SecondaryInspectorAction.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 05.11.23.
//

import SwiftUI

extension NoteSecondaryToolbar {
    @ViewBuilder func InspectorAction() -> some View {
        @Bindable var subviewValue = subviewManager
        
        Button("Inspektor", systemImage: "paintbrush") {
            subviewManager.showInspector.toggle()
        }
        .disabled(toolManager.activeItem == nil)
        .popover(isPresented: $subviewValue.showInspector) {
            InspectorView()
        }
        
    }
}
