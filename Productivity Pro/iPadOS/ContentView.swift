//
//  ContentView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 15.09.22.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var document: ProductivityProDocument
    
    @StateObject
    private var toolManager: ToolManager = ToolManager()
    
    @StateObject
    private var subviewManager: SubviewManager = SubviewManager()
    
    var body: some View {
        DocumentView(
            document: $document,
            subviewManager: subviewManager,
            toolManager: toolManager
        )
        .disabled(toolManager.showProgress)
        .overlay {
            if toolManager.showProgress {
                ProgressView("Processing...")
                    .progressViewStyle(.circular)
                    .tint(.accentColor)
                    .frame(width: 175, height: 100)
                    .background(.thickMaterial)
                    .cornerRadius(13, antialiased: true)
            }
        }
        .sheet(isPresented: $subviewManager.sharePDFSheet) {
            ShareSheet(
                showProgress: $toolManager.showProgress,
                subviewManager: subviewManager,
                toolManager: toolManager,
                document: $document,
                type: .pdf
            )
        }
        
    }
}