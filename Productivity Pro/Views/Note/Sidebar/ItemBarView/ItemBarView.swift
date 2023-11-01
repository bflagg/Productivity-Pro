//
//  ItemBarView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 30.10.23.
//

import SwiftUI

struct ItemBarView: View {
    @Environment(ToolManager.self) var toolManager
    var axis: Axis
    
    var body: some View {
        Group {
            if toolManager.activeItem != nil {
                ShapeBarView(axis: axis)
            }
        }
        .animation(.bouncy, value: toolManager.activeItem)
    }
}
