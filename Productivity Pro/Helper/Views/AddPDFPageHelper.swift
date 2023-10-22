//
//  AddPDFPageHelper.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.03.23.
//

import SwiftUI
import PDFKit
import VisionKit

//struct AddPDFPageHelper: ViewModifier {
//    
//    @Binding var document: Document
//    
//    @Bindable var toolManager: ToolManager
//    @Bindable var subviewManager: SubviewManager
//    
//    func body(content: Content) -> some View {
//        content
//            .fullScreenCover(
//                isPresented: $subviewManager.showScanDoc
//            ) {
//                ScannerView(cancelAction: {
//                    
//                    subviewManager.showScanDoc = false
//                    
//                }, resultAction: { result in
//                    
//                    switch result {
//                    case .success(let scan):
//                        add(scan: scan)
//                        
//                    case .failure(let error):
//                        print(error)
//                    }
//                    
//                    subviewManager.showScanDoc = false
//                })
//                .edgesIgnoringSafeArea(.bottom)
//            }
//            .fileImporter(
//                isPresented: $subviewManager.showImportFile,
//                allowedContentTypes: [.pdf],
//                allowsMultipleSelection: false
//            ) { result in
//                do {
//                    toolManager.showProgress = true
//                    
//                    guard let selectedFile: URL = try result.get().first else { return }
//                    if selectedFile.startAccessingSecurityScopedResource() {
//                        guard let input = PDFDocument(data: try Data(contentsOf: selectedFile)) else { return }
//                        defer { selectedFile.stopAccessingSecurityScopedResource() }
//                        
//                        add(pdf: input)
//                    } else {
//                        toolManager.showProgress = false
//                    }
//                    
//                } catch {
//                    toolManager.showProgress = false
//                }
//            }
//    }
//    
//    func add(scan: VNDocumentCameraScan) {
//        toolManager.showProgress = true
//        var count = 1
//        
//        for index in 0...scan.pageCount - 1 {
//            
//            let page = scan.imageOfPage(at: index)
//            let size = page.size
//            
//let canvasType: CanvasType = .pencilKit
//            
//            let newPage = Page(
//                type: .image,
//                canvasType: canvasType,
//                backgroundMedia: page.heicData(),
//                backgroundColor: "pagewhite",
//                backgroundTemplate: "blank",
//                isPortrait: size.width < size.height
//            )
//            
//            toolManager.preloadedMedia.insert(
//                nil, at: toolManager.selectedPage + count
//            )
//            
//            document.note.pages.insert(
//                newPage, at: toolManager.selectedPage + count
//            )
//            
//            count += 1
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            toolManager.selectedPage += 1
//            toolManager.showProgress = false
//        }
//    }
//    
//    func add(pdf: PDFDocument) {
//        var count = 1
//        
//        for index in 0...pdf.pageCount - 1 {
//            
//            guard let page = pdf.page(at: index) else { return }
//            let size = page.bounds(for: .mediaBox).size
//            
//            var data: Data?
//            var header: String?
//            
//            data = page.dataRepresentation
//            header = page.string?.components(separatedBy: .newlines).first
//            header = header?.trimmingCharacters(in: .whitespacesAndNewlines)
//            
//let canvasType: CanvasType = .pencilKit
//            
//            let newPage = Page(
//                type: .pdf,
//                canvasType: canvasType,
//                backgroundMedia: data,
//                header: header,
//                backgroundColor: "pagewhite",
//                backgroundTemplate: "blank",
//                isPortrait: size.width < size.height
//            )
//            
//            if let data = page.dataRepresentation {
//                toolManager.preloadedMedia.insert(
//                    PDFDocument(data: data), at: toolManager.selectedPage + count
//                )
//            } else {
//                toolManager.preloadedMedia.insert(
//                    nil, at: toolManager.selectedPage + count
//                )
//            }
//            
//            document.note.pages.insert(
//                newPage, at: toolManager.selectedPage + count
//            )
//            
//            count += 1
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            toolManager.selectedPage += 1
//            toolManager.showProgress = false
//        }
//    }
//    
//}
