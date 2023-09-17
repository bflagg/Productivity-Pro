//
//  DrawingView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 15.04.23.
//

import SwiftUI
import PencilKit

struct PencilKitViewWrapper: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.undoManager) var undoManager
    
    var size: CGSize
    
    @Binding var page: Page
    @Bindable var toolManager: ToolManager
    @Bindable var subviewManager: SubviewManager
    
    @State var pkCanvasView: PKCanvasView = PKCanvasView()
    @State var pkToolPicker = PKToolPicker()
    
    @State var drawingChanged: Bool = false
    @State var strokeCount: Int = 0
    
    var body: some View {
        
        PencilKitViewRepresentable(
            size: size,
            page: $page,
            toolManager: toolManager,
            subviewManager: subviewManager,
            canvasView: $pkCanvasView,
            toolPicker: $pkToolPicker,
            drawingChanged: $drawingChanged,
            strokeCount: $strokeCount
        )
        .onChange(of: drawingChanged) { value in
            didDrawingChange(value)
        }
        .onChange(of: toolManager.selectedPage) { _ in
            didSelectedPageChange()
            disableCanvasAvailability()
        }
        .onChange(of: toolManager.isCanvasEnabled) { isEnabled in
            didCanvasAvailabilityChange(isEnabled)
        }
        .onChange(of: scenePhase) { value in
            if value == .active {
                becameForeground()
            }
        }
        .frame(
            width: toolManager.zoomScale * getFrame().width,
            height: toolManager.zoomScale * getFrame().height
        )
        .scaleEffect(1/toolManager.zoomScale)
        .allowsHitTesting(toolManager.isCanvasEnabled)
    }
    
}
