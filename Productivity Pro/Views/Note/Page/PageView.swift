//
//  UnderlayingCanvasView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.11.22.
//

import SwiftUI
import PencilKit

struct PageView: View {
    @Environment(\.colorScheme) var cs
    
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    @AppStorage("defaultFont")
    var defaultFont: String = "Avenir Next"
    
    @AppStorage("defaultFontSize")
    var defaultFontSize: Double = 12
    
    var note: PPNoteModel
    var page: PPPageModel
    
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    
    let size: CGSize
    
    // MARK: - unchecked
    @State var isTargeted: Bool = true
    
    var pdfRendering: Bool = false
    var highRes: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                PageBackgroundView(page: page)
                BackgroundTemplateView(page: page, scale: $scale)
                
                if page.type == PPPageType.pdf.rawValue {
                    
//                    PageBackgroundPDF(
//                        page: page,
//                        document: $document,
//                        offset: $offset,
//                        toolManager: toolManager,
//                        isOverview: highRes,
//                        pdfRendering: pdfRendering
//                    )
                    
                } else if page.type == PPPageType.image.rawValue {
                    PageBackgroundScan(page: page, scale: $scale)
                }
                
            }
            .onTapGesture { onBackgroundTap() }
            
//
//            PageItemView(
//                document: $document,
//                page: $page,
//                offset: $offset,
//                toolManager: toolManager,
//                subviewManager: subviewManager,
//                highRes: highRes,
//                pdfRendering: pdfRendering
//            )
//            
//            DrawingView(
//                page: $page,
//                toolManager: toolManager,
//                subviewManager: subviewManager,
//                drawingModel: drawingModel,
//                pdfRendering: pdfRendering,
//                size: size
//            )
//            
//            SnapItemView(toolManager: toolManager, page: $page)
//                .scaleEffect(1/toolManager.zoomScale)
//                .allowsHitTesting(false)
            
        }
        .dropDestination(for: Data.self) { items, location in
            onDrop(items: items)
            return true
        }
        .disabled(subviewManager.isPresentationMode)
        .allowsHitTesting(!subviewManager.isPresentationMode)
        .frame(
            width: getFrame().width * toolManager.zoomScale,
            height: getFrame().height * toolManager.zoomScale
        )
            
    }
}
