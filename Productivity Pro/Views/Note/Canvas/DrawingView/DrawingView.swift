//
//  DrawingView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 15.04.23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.undoManager) var undoManager
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    @Bindable var page: PPPageModel
    @Binding var scale: CGFloat
    
    let size: CGSize
    
    @State var pkCanvasView: PKCanvasView = PKCanvasView()
    @State var pkToolPicker = PKToolPicker()
    @State var drawingChanged: Bool = false
    @State var strokeCount: Int = 0
    
    var body: some View {
        
        PKRepresentable(
            page: page,
            scale: $scale,
            canvasView: $pkCanvasView,
            toolPicker: $pkToolPicker,
            drawingChanged: $drawingChanged,
            strokeCount: $strokeCount,
            size: size
        )
        .zIndex(Double(page.items!.count + 10))
        .onChange(of: drawingChanged) { old, value in
            didDrawingChange(value)
        }
        .onChange(of: toolManager.selectedPage) {
            didSelectedPageChange()
            disableCanvasAvailability()
        }
        .onChange(of: toolManager.pencilKit) { old, isEnabled in
            didCanvasAvailabilityChange(isEnabled)
        }
        .onChange(of: scenePhase) { old, value in
            if value == .active {
                becameForeground()
            }
        }
        .frame(
            width: scale * getFrame().width,
            height: scale * getFrame().height
        )
        .scaleEffect(1 / scale)
    }
    
}