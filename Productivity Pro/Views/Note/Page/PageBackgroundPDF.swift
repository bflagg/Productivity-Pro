//
//  PageBackgroundPDF.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 28.03.23.
//

import SwiftUI
import PDFKit

struct PageBackgroundPDF: View, Equatable {
    
    @State private var renderedPreview: UIImage?
    @State private var renderedBackground: UIImage?
    @State private var pdfDocument: PDFDocument?
    
    @Binding var page: Page
    @Binding var offset: CGFloat
    
    @StateObject var toolManager: ToolManager
    
    var isOverview: Bool
    var body: some View {
        ZStack {
            
            if let rendering = renderedBackground, let preview = renderedPreview {
                Image(uiImage: offset == 0 ? rendering : preview)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: toolManager.zoomScale * getFrame().width,
                        height: toolManager.zoomScale * getFrame().height
                    )
                    .scaleEffect(1/toolManager.zoomScale)
                    .onChange(of: toolManager.zoomScale) { _ in
                        if toolManager.selectedTab == page.id{
                            render()
                        }
                    }
                
            } else {
               LoadingView()
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            if pdfDocument == nil {
                if let media = page.backgroundMedia {
                    pdfDocument = PDFDocument(data: media)
                }
            }
            
            if toolManager.selectedTab == page.id {
                render()
            } else if isOverview == true {
                renderOverview()
            } else {
                renderPreview()
            }
        }
        .onChange(of: offset) { value in
            if offset == 0 &&
                toolManager.selectedTab == page.id &&
                isOverview == false
            {
                render()
            }
        }
        .onDisappear {
            renderedBackground = nil
        }
    }
    
    func getFrame() -> CGSize {
        var frame: CGSize = .zero
        
        if page.isPortrait {
            frame = CGSize(width: shortSide, height: longSide)
        } else {
            frame = CGSize(width: longSide, height: shortSide)
        }
        
        return frame
    }
    
    static func == (
        lhs: PageBackgroundPDF,
        rhs: PageBackgroundPDF
    ) -> Bool {
        true
    }
    
    func renderPreview() {
        if renderedBackground == nil {
            let thumbnail = pdfDocument?.page(at: 0)?.thumbnail(of: CGSize(
                width: getFrame().width * 0.2,
                height: getFrame().width * 0.2
            ), for: .mediaBox)
            
            renderedBackground = thumbnail
            renderedPreview = thumbnail
        }
    }
    
    func renderOverview() {
        
    }
    
    func render() {
        let thumbnail = pdfDocument?.page(at: 0)?.thumbnail(of: CGSize(
            width: getFrame().width * 2.5 * toolManager.zoomScale,
            height: getFrame().width * 2.5 * toolManager.zoomScale
        ), for: .mediaBox)
        
        renderedBackground = thumbnail
    }
    
    @ViewBuilder func LoadingView() -> some View {
        Text("Loading...")
            .font(.system(size: 20 * toolManager.zoomScale))
            .frame(
                width: toolManager.zoomScale * getFrame().width,
                height: toolManager.zoomScale * getFrame().height
            )
            .scaleEffect(1/toolManager.zoomScale)
    }
    
}
