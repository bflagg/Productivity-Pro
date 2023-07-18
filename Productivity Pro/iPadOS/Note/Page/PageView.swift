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
    
    @AppStorage("defaultFont")
    var defaultFont: String = "Avenir Next"
    
    @AppStorage("defaultFontSize")
    var defaultFontSize: Double = 12
    
    @Binding var document: ProductivityProDocument
    @Binding var page: Page
    
    @Binding var offset: CGFloat
    
    @StateObject var toolManager: ToolManager
    @StateObject var subviewManager: SubviewManager
    
    @State var isTargeted: Bool = true
    
    var pdfRendering: Bool = false
    var highRes: Bool = false
    
    let size: CGSize
    
    var body: some View {
        ZStack {
            ZStack {
                PageBackgroundView(page: $page, toolManager: toolManager)
                
                BackgroundTemplateView(
                    page: page,
                    scale: toolManager.zoomScale
                )
                
                if page.type == .pdf {
                    
                    PageBackgroundPDF(
                        page: page,
                        document: $document.document,
                        offset: $offset,
                        toolManager: toolManager,
                        isOverview: highRes,
                        pdfRendering: pdfRendering
                    ).equatable()
                    
                } else if page.type == .image {
                    
                    PageBackgroundScan(
                        document: $document,
                        page: page,
                        offset: $offset,
                        toolManager: toolManager,
                        isOverview: highRes,
                        pdfRendering: pdfRendering
                    ).equatable()
                    
                }
                
            }
            .onTapGesture { onBackgroundTap() }
            
            PageItemView(
                document: $document,
                page: $page,
                offset: $offset,
                toolManager: toolManager,
                subviewManager: subviewManager,
                highRes: highRes,
                pdfRendering: pdfRendering
            )
            
            DrawingView(
                page: $page,
                toolManager: toolManager,
                subviewManager: subviewManager,
                pdfRendering: pdfRendering,
                size: size
            )
            
            SnapItemView(toolManager: toolManager, page: $page)
                .scaleEffect(1/toolManager.zoomScale)
                .allowsHitTesting(false)
            
        }
        .dropDestination(for: Data.self) { items, location in
            onDrop(items: items)
            return true
        }
        .disabled(subviewManager.isPresentationMode)
        .allowsHitTesting(!subviewManager.isPresentationMode)
        .modifier(iPhoneInteraction())
        .frame(
            width: getFrame().width * toolManager.zoomScale,
            height: getFrame().height * toolManager.zoomScale
        )
            
    }
}
