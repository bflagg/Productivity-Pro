//
//  NavigationTitleMenuView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 29.09.22.
//

import SwiftUI
import PDFKit
import PencilKit

struct NoteToolbarTitleMenu: View {
    
    @AppStorage("startDate") var startDate: String = ""
    @AppStorage("fullAppUnlocked") var isFullAppUnlocked: Bool = false
    
    @Environment(\.horizontalSizeClass) var hsc
    @Binding var document: ProductivityProDocument
    
    @StateObject var subviewManager: SubviewManager
    @StateObject var toolManager: ToolManager
    
    
    var body: some View {
        
        Section {
            
            TitleShareButton(
                toolManager: toolManager,
                subviewManager: subviewManager,
                sharePDF: { sharePDF() }
            )
            
            Button(action: {
                toolManager.isCanvasEnabled = false
                print()
            }) {
                Label("Print", systemImage: "printer")
            }
            
        }
        
        if hsc == .compact {
            Button(action: {
                toolManager.isCanvasEnabled = false
                UITabBar.appearance().isHidden = false
                subviewManager.overviewSheet.toggle()
            }) {
                Label("Overview", systemImage: "square.grid.2x2")
            }
        }
        
        Section {
            Button(action: {
                toolManager.isCanvasEnabled = false
                subviewManager.settingsSheet.toggle()
            }) {
                Label("Settings", systemImage: "gearshape")
            }
            
            Button(action: {
                toolManager.isCanvasEnabled = false
                subviewManager.feedbackView.toggle()
            }) {
                Label("Feedback", systemImage: "star")
            }
        }
        
        if !isFullAppUnlocked {
            Section {
                Button(action: {
                    toolManager.isCanvasEnabled = false
                    subviewManager.showUnlockView = true
                }) {
                    Label("Unlock Full Version", systemImage: "cart")
                }
            }
        }
        
    }
    
    func sharePDF() {
        toolManager.showProgress = true
        Task(priority: .userInitiated) {
            await MainActor.run {
                toolManager.pdfRendering = renderPDF()
            }
            
            toolManager.showProgress = false
            subviewManager.sharePDFSheet.toggle()
        }
    }
    func print() {
        toolManager.showProgress = true
        Task(priority: .userInitiated) {
            await MainActor.run {
                toolManager.pdfRendering = renderPDF()
            }
            
            toolManager.showProgress = false
            subviewManager.showPrinterView.toggle()
        }
    }
    
    @MainActor func renderPDF() -> URL {
        
        let name: String = document.document.url!
            .deletingPathExtension().lastPathComponent
        
        let url = URL.cachesDirectory.appending(
            path: "\(name).pdf"
        )
        
        guard let pdf = CGContext(url as CFURL, mediaBox: nil, nil) else {
            return url
        }
        
        let tm = ToolManager()
        tm.scrollOffset = CGPoint(x: 0, y: 0)
        tm.zoomScale = 1
        
        for page in document.document.note.pages {
            
            let renderedCanvas = renderCanvas(page: page)
            var box = CGRect(
                x: 0,
                y: 0,
                width: getFrame(page: page).width,
                height: getFrame(page: page).height
            )
            
            pdf.beginPage(mediaBox: &box)
            
            var view: some View {
                ZStack {
                    
                    PageView(
                        document: $document,
                        page: .constant(page),
                        offset: .constant(0),
                        toolManager: tm,
                        subviewManager: subviewManager,
                        pdfRendering: true,
                        highRes: true,
                        size: getFrame(page: page)
                    )
                    
                    Image(uiImage: renderedCanvas)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: getFrame(page: page).width,
                            height: getFrame(page: page).height
                        )
                    
                }
                .frame(
                    width: getFrame(page: page).width,
                    height: getFrame(page: page).height
                )
            }
            
            let renderer = ImageRenderer(content: view)
            
            renderer.render { size, context in
                context(pdf)
            }
            
            pdf.endPDFPage()
            
        }
        
        pdf.closePDF()
        
        
        return url
    }
    
    func renderCanvas(page: Page) -> UIImage {
        var image: UIImage = UIImage()
        
        UITraitCollection(
            userInterfaceStyle: colorScheme(page: page)
        ).performAsCurrent {
            
            try? image = PKDrawing(data: page.canvas).image(
                from: CGRect(
                    x: 0,
                    y: 0,
                    width: getFrame(page: page).width,
                    height: getFrame(page: page).height
                ),
                scale: 70
            )
        }
        
        return image
    }
    
    func getFrame(page: Page) -> CGSize {
        var frame: CGSize = .zero
        
        if page.isPortrait {
            frame = CGSize(width: shortSide, height: longSide)
        } else {
            frame = CGSize(width: longSide, height: shortSide)
        }
        
        return frame
    }
    
    func colorScheme(page: Page) -> UIUserInterfaceStyle {
        var cs: UIUserInterfaceStyle = .dark
        
        if  page.backgroundColor == "pagewhite" ||  page.backgroundColor == "white" ||  page.backgroundColor == "pageyellow" ||  page.backgroundColor == "yellow"{
            cs = .light
        }
        
        return cs
    }
    
    
}

