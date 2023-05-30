//
//  AddPDFPageHelper.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 27.03.23.
//

import SwiftUI
import PDFKit
import VisionKit

struct AddPDFPageHelper: ViewModifier {
    
    @Binding var document: Productivity_ProDocument
    
    @StateObject var toolManager: ToolManager
    @StateObject var subviewManager: SubviewManager
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $subviewManager.showScanDoc) {
                ScannerHelperView(cancelAction: {
                    subviewManager.showScanDoc.toggle()
                }, resultAction: { result in
                    
                    switch result {
                    case .success(let scan):
                        toolManager.showProgress = true
                        Task(priority: .userInitiated) {
                            await MainActor.run {
                                add(scan: scan)
                            }
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    subviewManager.showScanDoc.toggle()
                })
                .edgesIgnoringSafeArea(.bottom)
            }
            .fileImporter(
                isPresented: $subviewManager.showImportFile,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                do {
                    toolManager.showProgress = true
                    
                    guard let selectedFile: URL = try result.get().first else { return }
                    if selectedFile.startAccessingSecurityScopedResource() {
                        guard let input = PDFDocument(data: try Data(contentsOf: selectedFile)) else { return }
                        defer { selectedFile.stopAccessingSecurityScopedResource() }
                        
                        addPDFs(pdf: input)
                    } else {
                        toolManager.showProgress = false
                    }
                    
                } catch {
                    toolManager.showProgress = false
                }
            }
    }
    
    func convert(scan: VNDocumentCameraScan) -> PDFDocument {
        let pdfDocument = PDFDocument()
        for pageIndex in 0..<scan.pageCount {
            let pageImage = scan.imageOfPage(at: pageIndex)
            let pdfPage = PDFPage(image: pageImage)
            
            if let page = pdfPage {
                pdfDocument.insert(page, at: pageIndex)
            }
        }
        
        return pdfDocument
    }
    
    func add(scan: VNDocumentCameraScan) {
        var count = 1
        
        for index in 0...scan.pageCount - 1 {
            
            let page = scan.imageOfPage(at: index)
            let size = page.size
            
            let newPage = Page(
                type: .image,
                backgroundMedia: page.pngData(),
                backgroundColor: "white",
                backgroundTemplate: "none",
                isPortrait: size.width < size.height
            )
            
            document.document.note.pages.insert(
                newPage, at: toolManager.selectedPage + count
            )
            
            
            count += 1
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 1000000000)
            toolManager.selectedPage += count - 1
            toolManager.showProgress = false
        }
        
    }
    
    func addPDFs(pdf: PDFDocument) {
        var count = 1
        
        for index in 0...pdf.pageCount - 1 {
            
            let page = pdf.page(at: index)
            let size = page!.bounds(for: .mediaBox).size
            
            let newPage = Page(
                type: .pdf,
                backgroundMedia: page?.dataRepresentation,
                backgroundColor: "white",
                backgroundTemplate: "none",
                isPortrait: size.width < size.height
            )
            
            document.document.note.pages.insert(
                newPage, at: toolManager.selectedPage + count
            )
            
            
            count += 1
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 1000000000)
            toolManager.selectedPage += count - 1
            toolManager.showProgress = false
        }
        
    }
    
}
